# frozen_string_literal: true

# This module is a part of KOFTA SNMP Collector.
# Gets called as a recurring task by Sidekiq or any other ActiveJob queue
# engine. The only input argument needed is the Device object.
# Device must have at least 1 metric assigned to it.
class SnmpWorkerJob < ActiveJob::Base
  queue_as :default
  require 'snmp'
  require 'influxdb'
  require 'yajl/json_gem'

  # This is a definition of metric class.
  # Will use it to store processed metric data before sending it to InfluxDB.
  class Measurement
    attr_accessor :name, :value, :tags, :timestamp
    def initialize(name, value, tags, timestamp)
      @name = name
      @value = value
      @tags = tags
      @timestamp = timestamp
    end
  end

  class MetricTable
    attr_reader :type, :data, :index, :derive, :excludes, :timestamp
    def initialize(type, data, index, derive, excludes, timestamp)
      @type = type
      @data = data
      @index = index
      @derive = derive
      @excludes = excludes
      @timestamp = timestamp
    end
  end

  def perform(device)
    datasources = device.datatypes.to_a
    # Split datasources into 2 groups:
    @single_metrics = datasources.select { |metric| metric unless metric.table }
    @table_metrics = datasources.select { |metric| metric if metric.table }
    # Fill in device-wide tags
    @device_tags = {
      hostname: device.address,
      title: device.devname,
      city: device.city,
      group: device.group
    }
    puts "Here are the device tags for #{device.address}: #{@device_tags.inspect}."
    @json_packer   = Yajl::Encoder.new
    @json_unpacker = Yajl::Parser.new(symbolize_keys: false)

    # Store device query interval
    # for derive processing.
    @derive_interval = device.query_interval

    # Get access to job-local variables:
    @redis = Redis.new(
      host: REDIS_CONFIG['host'],
      port: REDIS_CONFIG['port'],
      db:   REDIS_CONFIG['worker_db']
    )

    redis_derives = "#{@device_tags[:hostname]}.derives"
    @job_data =
      if @redis.exists(redis_derives)
        @json_unpacker.parse(@redis.get(redis_derives))
      else
        {}
      end

    # Create SNMP params hash
    @snmp_params = {
      host: device.address,
      community: device.snmp_community
    }
    # Open SNMP Manager
    @snmp = SNMP::Manager.new(@snmp_params)

    # Record starting time, for query_time metric:
    start_time = Time.now

    # Open InfluxDB connection:
    @influx = InfluxDB::Client.new udp: {
      host: INFLUX_CONFIG['host'],
      port: INFLUX_CONFIG['port']
    }

    # Fill indexes first:
    index_list = @table_metrics.map(&:index_oid).uniq
    @indexes = get_table_indexes(index_list)

    # Pre-create metric array:
    @metric_data = read_metric_data

    # Count querying time and push it as a metric point
    query_time = Time.now.to_f - start_time.to_f
    @metric_data.push Measurement.new('query_duration', query_time * 1000,
                                      @device_tags, Time.now)

    # Same goes for response time (ping).
    @metric_data.push Measurement.new('response_time',
                                      device_ping(@snmp_params[:host]),
                                      @device_tags, Time.now)

    # Post data to InfluxDB:
    influx_batch = []
    @metric_data.each do |measurement|
      influx_batch << { series: measurement.name,
                        values: { value: measurement.value },
                        tags: measurement.tags,
                        # InfluxDB demands time in nanoseconds,
                        # so we have to do this:
                        timestamp: (measurement.timestamp.to_f * 1_000_000_000).to_i
                      }
    end
    influx_batch.in_groups(500, false) { |batch_part|
      @influx.write_points(batch_part)
    }
    @redis.setex redis_derives,
                 @derive_interval * 3,
                 @json_packer.encode(@job_data)

  end

  def device_ping(host)
    require 'net/ping/external'

    # Spawn ping object:
    ping = Net::Ping::External.new(host)

    # Perform an actual ping and return RTT (in millis)
    ping.duration * 1000 if ping.ping?
  end

  def read_metric_data
    metric_data = []

    # Let's not ask for current time 9000 times,
    # and use one time per query instead.
    single_query_time = Time.now

    # Get all non-table metrics:
    # (TODO: Try to get_bulk all non-table metrics in one query instead)
    @single_metrics.each do |metric|
      metric_data.push Measurement.new(metric.metric_type, @snmp.get_value(metric.oid).to_i, @device_tags, single_query_time)
    end

    table_threads = []
    raw_tables = []
    # Gather all table metrics for future processing:
    @table_metrics.in_groups(4, false).each do |group|
      table_threads << Thread.new do
        thread_snmp = SNMP::Manager.new(@snmp_params)
        group.each do |metric|
          raw_tables.push MetricTable.new(metric.metric_type, bulkwalk(thread_snmp, metric.oid),
                                          metric.index_oid, metric.derive, metric.excludes, Time.now)
        end
      end
    end

    # Wait for table threads to finish:
    table_threads.each(&:join)

    # Create metrics for freshly harvested tables:
    raw_tables.each do |metric_table|
      # Set timestamp key for job-local vars (in case if this table is a Derive
      time_key = "kofta:#{@device_tags[:hostname]}:#{metric_table.type}:timestamp"
      metric_table.data.each do |oid, data|
        instance = @indexes[metric_table.index][oid]
        next if instance =~ /#{metric_table.excludes}/
        if instance.to_s.include?('.')
          instance, subinstance = instance.split('.', 2)
        else
          subinstance = 'none'
        end

        if metric_table.derive
          keyname = "kofta:#{@device_tags[:hostname]}:#{metric_table.type}:#{instance}:#{subinstance}"
          if @job_data.key?(keyname)
            old_data = @job_data[keyname].to_i
            old_time = Time.at(@job_data[time_key].to_i)
            @job_data[keyname] = data.to_i
            data = (data.to_i - old_data.to_i) / (metric_table.timestamp - old_time)
            metric_data.push Measurement.new(
              metric_table.type, data.to_i,
              @device_tags.merge(instance: instance, subinstance: subinstance),
              metric_table.timestamp)
          else
            @job_data[keyname] = data
          end
        else
          metric_data.push Measurement.new(
            metric_table.type, data,
            @device_tags.merge(instance: instance, subinstance: subinstance),
            metric_table.timestamp)
        end
      end
      @job_data[time_key] = metric_table.timestamp.to_i
    end
    # GC.start
    metric_data
  end

  # Performs a BULKWALK across given object tree.
  # Much faster than simple SNMP Walk, so here it is.
  # Returns a hash of {oid_last_number: value}, which then gets merged
  #  with indexer OID hash (which is also generated here).
  def bulkwalk(snmp, object)
    root = extract_oid(snmp, object)
    last, oid, results = false, root.dup, {}
    root = root.split('.').map(&:to_i)
    until last
      snmp.get_bulk(0, 25, oid).each_varbind { |vb|
        oid = vb.oid
        (last = true; break) unless oid[0..root.size - 1] == root
        results[vb.oid.last] = vb.value.asn1_type =~ /STRING/ ? vb.value.to_s : vb.value.to_i
      }
    end
    results
  end

  # Returns numeric OID (as string) if symbolic is given.
  def extract_oid(snmp, object)
    snmp.mib.oid(object).to_s
  end

  # Parses table metrics and gets list of unique index tables,
  #  fetches these tables from the device and returns a hash of hashes:
  # {indexTable: {oid: value,},}
  def get_table_indexes(index_list)
    # Prepare indexes hash:
    indexes = {}
    # Extract list of indexes to work on,
    # and fill the hash:
    index_list.each do |index|
      indexes[index] = bulkwalk(@snmp, index)
    end
    indexes
  end

end
