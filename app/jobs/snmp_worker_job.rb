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
  # Returns a hash of {oid_last_number: value}, which then gets merged
  #  with indexer OID hash (which is also generated here).
  def bulkwalk(object)
    root = extract_oid(object)
    # The only way we could get >1024 records in SNMP table
    # is by walking something in ifTable, so if we do,
    # we set maxrows equal to ifTable size.
    maxrows = get_table_size(object)
    last, oid, results = false, root.dup, {}
    root = root.split('.').map{|chr|chr.to_i}
    while not last
      vbs = @snmp.get_bulk(0, maxrows, oid).each_varbind do |vb|
        oid = vb.oid
        (last = true; break) if not oid[0..root.size-1] == root
        results[vb.oid.last] = vb.value.asn1_type =~ /STRING/ ? vb.value.to_s : vb.value.to_i
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

  # This one could be rewritten in the future,
  # for now it's awfully simple.
  # +1 is here just in case, I'll remove it if it's unneeded.
  def get_table_size(object)
    object =~ /IF-MIB::if/ ? @snmp.get_value('IF-MIB::ifNumber.0') + 1 : 1024
  end
end
