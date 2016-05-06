class SnmpWorkerJob < ActiveJob::Base
  queue_as :default
  require 'snmp'

  def perform(device)
    # Get datasources to query from this device
    datasources = device.datatypes.to_a
    @single_metrics = datasources.select { |metric| metric if not metric.table }
    @table_metrics = datasources.select { |metric| metric if metric.table }
    # Fill in device-wide tags
    device_tags = {
      host: device.address,
      name: device.devname,
      city: device.city,
      group: device.group
    }
    # Open SNMP Manager
    @snmp = SNMP::Manager.new(
      host: device.address,
      community: device.snmp_community
    )

    # Fill indexes first:
    @indexes = get_table_indexes(@table_metrics.map{ |i| i.index_oid }.uniq)
  end

  # Performs a BULKWALK across given object tree.
  # Much faster than simple SNMP Walk, so here it is.
  # Returns a hash of {oid: value}, which then gets merged
  #  with indexer OID hash (which is also generated here).
  def bulkwalk(object)
    root = extract_oid(object)
    last, oid, results = false, root.dup, {}
    root = root.split('.').map{|chr|chr.to_i}
    while not last
      vbs = @snmp.get_bulk(0, 1024, oid).each_varbind do |vb|
        oid = vb.oid
        (last = true; break) if not oid[0..root.size-1] == root
        results[vb.oid.to_s] = vb.value.asn1_type =~ /STRING/ ? vb.value.to_s : vb.value.to_i
      end
    end
    results
  end

  # Returns numeric OID (as string) if symbolic is given.
  def extract_oid(object)
    @snmp.mib.oid(object).to_s
  end

  # Parses table metrics and gets list of unique index tables,
  #  fetches these tables from the device and returns a hash of hashes:
  # {indexTable: {oid: value,},}
  def get_table_indexes(indexList)
    # Prepare indexes hash:
    indexes = {}
    # Extract list of indexes to work on,
    # and fill the hash:
    indexList.each do |index|
      indexes[index] = bulkwalk(index)
    end
  end
end
