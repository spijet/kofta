# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
datatypes = Datatype.create(
  [
    {
      name: 'System Uptime',
      oid: 'SNMPv2-MIB::sysUpTime.0',
      excludes: '',
      table: false,
      index_oid: '',
      metric_type: 'snmp_uptime'
    },
    {
      name: 'Interface Link Speed',
      oid: 'IF-MIB::ifHighSpeed',
      excludes: '^(802|VI|Vl|Vi|Se|Lo|Nu|Tu|Vo|Vt|Aux|Console|NULL|System|MTun|InLoop|BV1|mcast|40\d\d)',
      table: true,
      index_oid: 'IF-MIB::ifName',
      metric_type: 'snmp_if_linkspeed'
    },
    {
      name: 'Interface RX Bytes',
      oid: 'IF-MIB::ifHCInOctets',
      excludes: '^(802|VI|Vl|Vi|Se|Lo|Nu|Tu|Vo|Vt|Aux|Console|NULL|System|MTun|InLoop|BV1|mcast|40\d\d)',
      table: true,
      index_oid: 'IF-MIB::ifName',
      metric_type: 'snmp_if_traffic_rx'
    },
    {
      name: 'Interface TX Bytes',
      oid: 'IF-MIB::ifHCOutOctets',
      excludes: '^(802|VI|Vl|Vi|Se|Lo|Nu|Tu|Vo|Vt|Aux|Console|NULL|System|MTun|InLoop|BV1|mcast|40\d\d)',
      table: true,
      index_oid: 'IF-MIB::ifName',
      metric_type: 'snmp_if_traffic_tx'
    },
    {
      name: 'Interface RX Bytes (lowres)',
      oid: 'IF-MIB::ifInOctets',
      excludes: '^(802|VI|Vl|Vi|Se|Lo|Nu|Tu|Vo|Vt|Aux|Console|NULL|System|MTun|InLoop|BV1|mcast|40\d\d)',
      table: true,
      index_oid: 'IF-MIB::ifName',
      metric_type: 'snmp_if_traffic_rx'
    },
    {
      name: 'Interface TX Bytes (lowres)',
      oid: 'IF-MIB::ifOutOctets',
      excludes: '^(802|VI|Vl|Vi|Se|Lo|Nu|Tu|Vo|Vt|Aux|Console|NULL|System|MTun|InLoop|BV1|mcast|40\d\d)',
      table: true,
      index_oid: 'IF-MIB::ifName',
      metric_type: 'snmp_if_traffic_tx'
    },
    {
      name: 'Interface RX Unicast Frames',
      oid: 'IF-MIB::ifHCInUcastPkts',
      excludes: '^(802|VI|Vl|Vi|Se|Lo|Nu|Tu|Vo|Vt|Aux|Console|NULL|System|MTun|InLoop|BV1|mcast|40\d\d)',
      table: true,
      index_oid: 'IF-MIB::ifName',
      metric_type: 'snmp_if_ucast_rx'
    },
    {
      name: 'Interface TX Unicast Frames',
      oid: 'IF-MIB::ifHCOutUcastPkts',
      excludes: '^(802|VI|Vl|Vi|Se|Lo|Nu|Tu|Vo|Vt|Aux|Console|NULL|System|MTun|InLoop|BV1|mcast|40\d\d)',
      table: true,
      index_oid: 'IF-MIB::ifName',
      metric_type: 'snmp_if_ucast_tx'
    },
    {
      name: 'Interface RX Multicast Frames',
      oid: 'IF-MIB::ifHCInMulticastPkts',
      excludes: '^(802|VI|Vl|Vi|Se|Lo|Nu|Tu|Vo|Vt|Aux|Console|NULL|System|MTun|InLoop|BV1|mcast|40\d\d)',
      table: true,
      index_oid: 'IF-MIB::ifName',
      metric_type: 'snmp_if_mcast_rx'
    },
    {
      name: 'Interface TX Multicast Frames',
      oid: 'IF-MIB::ifHCOutMulticastPkts',
      excludes: '^(802|VI|Vl|Vi|Se|Lo|Nu|Tu|Vo|Vt|Aux|Console|NULL|System|MTun|InLoop|BV1|mcast|40\d\d)',
      table: true,
      index_oid: 'IF-MIB::ifName',
      metric_type: 'snmp_if_mcast_tx'
    },
    {
      name: 'Interface RX Broadcast Frames',
      oid: 'IF-MIB::ifHCInBroadcastPkts',
      excludes: '^(802|VI|Vl|Vi|Se|Lo|Nu|Tu|Vo|Vt|Aux|Console|NULL|System|MTun|InLoop|BV1|mcast|40\d\d)',
      table: true,
      index_oid: 'IF-MIB::ifName',
      metric_type: 'snmp_if_bcast_rx'
    },
    {
      name: 'Interface TX Broadcast Frames',
      oid: 'IF-MIB::ifHCOutBroadcastPkts',
      excludes: '^(802|VI|Vl|Vi|Se|Lo|Nu|Tu|Vo|Vt|Aux|Console|NULL|System|MTun|InLoop|BV1|mcast|40\d\d)',
      table: true,
      index_oid: 'IF-MIB::ifName',
      metric_type: 'snmp_if_bcast_tx'
    },
  ]
)
