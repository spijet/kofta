# This module is a part of KOFTA SNMP Collector.
# Gets called as a recurring task by Sidekiq or any other ActiveJob queue
# engine. The only input argument needed is the Device object.
# Device must have at least 1 metric assigned to it.
class SnmpWorkerJob < ActiveJob::Base
  queue_as :default
  require 'snmp'
  require 'influxdb'

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
    attr_reader :type, :data, :index, :excludes
    def initialize(type, data, index, excludes)
      @type = type
      @data = data
      @index = index
      @excludes = excludes
    end
  end

  def perform(device)
    # Get datasources to query from this device
    datasources = device.datatypes.to_a
    @single_metrics = datasources.select { |metric| metric unless metric.table }
    @table_metrics = datasources.select { |metric| metric if metric.table }
    # Fill in device-wide tags
    @device_tags = {
      hostname: device.address,
      title: device.devname,
      city: device.city,
      group: device.group
    }

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
      host: ENV['INFLUXDB_HOST'],
      port: ENV['INFLUXDB_PORT']
    }

    # Fill indexes first:
    index_list = @table_metrics.map(&:index_oid).uniq
    @indexes = get_table_indexes(index_list)

    # Pre-create metric array:
    @metric_data = read_metric_data

    # Count querying time and push it as a metric point
    query_time = Time.now.to_f - start_time.to_f
    @metric_data.push Measurement.new('query_duration', query_time * 1000, @device_tags, Time.now)

    # Same goes for response time (ping).
    @metric_data.push Measurement.new('response_time', device_ping(@snmp_params[:host]), @device_tags, Time.now)

    # Post data to InfluxDB:
    @metric_data.each do |measurement|
      point = { values: { value: measurement.value },
                tags: measurement.tags,
                # InfluxDB demands time in nanoseconds, so we have to do this:
                timestamp: (measurement.timestamp.to_f * 1_000_000_000).to_i
              }
      @influx.write_point(measurement.name, point)
    end
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

    # Get all non-table metrics:
    # (TODO: Try to get_bulk all non-table metrics in one query instead)
    @single_metrics.each do |metric|
      metric_data.push Measurement.new(metric.metric_type, @snmp.get_value(metric.oid).to_i, @device_tags, Time.now)
    end

    table_threads = []
    raw_tables = []
    # Gather all table metrics for future processing:
    @table_metrics.each do |metric|
      table_threads << Thread.new do
        thread_snmp = SNMP::Manager.new(@snmp_params)
        raw_tables.push MetricTable.new(metric.metric_type, bulkwalk(thread_snmp, metric.oid),
                                        metric.index_oid, metric.excludes)
      end
    end

    # Wait for table threads to finish:
    table_threads.each(&:join)

    # Create metrics for freshly harvested tables:
    raw_tables.each do |metric_table|
      metric_table.data.each do |oid, data|
        instance = @indexes[metric_table.index][oid]
        metric_data.push Measurement.new(
          metric_table.type, data, @device_tags.merge(instance: instance),
          Time.now
        ) unless instance =~ /#{metric_table.excludes}/
      end
    end
    metric_data
  end

  # Performs a BULKWALK across given object tree.
  # Much faster than simple SNMP Walk, so here it is.
  # Returns a hash of {oid_last_number: value}, which then gets merged
  #  with indexer OID hash (which is also generated here).
  def bulkwalk(snmp,object)
    root = extract_oid(snmp,object)
    # The only way we could get >1024 records in SNMP table
    # is by walking something in ifTable, so if we do,
    # we set maxrows equal to ifTable size.
    #maxrows = get_table_size(object)
    last, oid, results = false, root.dup, {}
    root = root.split('.').map(&:to_i)
    while !last
      snmp.get_bulk(0, 18, oid).each_varbind do |vb|
        oid = vb.oid
        (last = true; break) unless oid[0..root.size - 1] == root
        results[vb.oid.last] = vb.value.asn1_type =~ /STRING/ ? vb.value.to_s : vb.value.to_i
      end
    end
    results
  end

  # Returns numeric OID (as string) if symbolic is given.
  def extract_oid(snmp,object)
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
      indexes[index] = bulkwalk(@snmp,index)
    end
    indexes
  end

  # This one could be rewritten in the future,
  # for now it's awfully simple.
  # +1 is here just in case, I'll remove it if it's unneeded.
# def get_table_size(object)
#   devmodel = @snmp.get_value('SNMPv2-MIB::sysDescr.0')
#   # Quick fix for Huawei NE40E, which ignores bulk queries if bulkrows value is too high.
#   # Possibly affects other Huawei devices as well.
#  #case devmodel
#  #when /HUAWEI/
#  #  100
#  #when /DGS-3620/
#  #  20
#  #else
#  #  object =~ /IF-MIB::if/ ? @snmp.get_value('IF-MIB::ifNumber.0').to_i + 1 : 1024
#  #end
#   20
# end
end
