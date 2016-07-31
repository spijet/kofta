Datatype.create!([
  {name: "System Uptime", oid: "SNMPv2-MIB::sysUpTime.0", excludes: "", table: false, index_oid: "", metric_type: "snmp_uptime", derive: nil},
  {name: "Interface Link Speed", oid: "IF-MIB::ifHighSpeed", excludes: "", table: true, index_oid: "IF-MIB::ifName", metric_type: "snmp_if_linkspeed", derive: nil},
  {name: "Interface RX Bytes", oid: "IF-MIB::ifHCInOctets", excludes: "", table: true, index_oid: "IF-MIB::ifName", metric_type: "snmp_if_traffic_rx", derive: nil},
  {name: "Interface TX Bytes", oid: "IF-MIB::ifHCOutOctets", excludes: "", table: true, index_oid: "IF-MIB::ifName", metric_type: "snmp_if_traffic_tx", derive: nil},
  {name: "Interface RX Bytes (lowres)", oid: "IF-MIB::ifInOctets", excludes: "", table: true, index_oid: "IF-MIB::ifName", metric_type: "snmp_if_traffic_rx", derive: nil},
  {name: "Interface TX Bytes (lowres)", oid: "IF-MIB::ifOutOctets", excludes: "", table: true, index_oid: "IF-MIB::ifName", metric_type: "snmp_if_traffic_tx", derive: nil},
  {name: "Interface RX Unicast Frames", oid: "IF-MIB::ifHCInUcastPkts", excludes: "", table: true, index_oid: "IF-MIB::ifName", metric_type: "snmp_if_ucast_rx", derive: nil},
  {name: "Interface TX Unicast Frames", oid: "IF-MIB::ifHCOutUcastPkts", excludes: "", table: true, index_oid: "IF-MIB::ifName", metric_type: "snmp_if_ucast_tx", derive: nil},
  {name: "Interface RX Multicast Frames", oid: "IF-MIB::ifHCInMulticastPkts", excludes: "", table: true, index_oid: "IF-MIB::ifName", metric_type: "snmp_if_mcast_rx", derive: nil},
  {name: "Interface TX Multicast Frames", oid: "IF-MIB::ifHCOutMulticastPkts", excludes: "", table: true, index_oid: "IF-MIB::ifName", metric_type: "snmp_if_mcast_tx", derive: nil},
  {name: "Interface RX Broadcast Frames", oid: "IF-MIB::ifHCInBroadcastPkts", excludes: "", table: true, index_oid: "IF-MIB::ifName", metric_type: "snmp_if_bcast_rx", derive: nil},
  {name: "Interface TX Broadcast Frames", oid: "IF-MIB::ifHCOutBroadcastPkts", excludes: "", table: true, index_oid: "IF-MIB::ifName", metric_type: "snmp_if_bcast_tx", derive: nil}
])
