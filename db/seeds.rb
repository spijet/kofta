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
      derive: false,
      index_oid: '',
      metric_type: 'snmp_uptime'
    },
    {
      name: 'Interface Link Speed',
      oid: 'IF-MIB::ifHighSpeed',
      excludes: '^(802|VI|Vl|Vi|Se|Lo|Nu|Tu|Vo|Vt|Aux|Console|NULL|System|MTun|InLoop|BV1|mcast|test|pim|TEST)',
      table: true,
      derive: false,
      index_oid: 'IF-MIB::ifName',
      metric_type: 'snmp_if_linkspeed'
    },
    {
      name: 'Interface RX Bytes',
      oid: 'IF-MIB::ifHCInOctets',
      excludes: '^(802|VI|Vl|Vi|Se|Lo|Nu|Tu|Vo|Vt|Aux|Console|NULL|System|MTun|InLoop|BV1|mcast|test|pim|TEST)',
      table: true,
      derive: true,
      index_oid: 'IF-MIB::ifName',
      metric_type: 'snmp_if_traffic_rx'
    },
    {
      name: 'Interface TX Bytes',
      oid: 'IF-MIB::ifHCOutOctets',
      excludes: '^(802|VI|Vl|Vi|Se|Lo|Nu|Tu|Vo|Vt|Aux|Console|NULL|System|MTun|InLoop|BV1|mcast|test|pim|TEST)',
      table: true,
      derive: true,
      index_oid: 'IF-MIB::ifName',
      metric_type: 'snmp_if_traffic_tx'
    },
    {
      name: 'Interface RX Bytes (lowres)',
      oid: 'IF-MIB::ifInOctets',
      excludes: '^(802|VI|Vl|Vi|Se|Lo|Nu|Tu|Vo|Vt|Aux|Console|NULL|System|MTun|InLoop|BV1|mcast|test|pim|TEST)',
      table: true,
      derive: true,
      index_oid: 'IF-MIB::ifName',
      metric_type: 'snmp_if_traffic_rx'
    },
    {
      name: 'Interface TX Bytes (lowres)',
      oid: 'IF-MIB::ifOutOctets',
      excludes: '^(802|VI|Vl|Vi|Se|Lo|Nu|Tu|Vo|Vt|Aux|Console|NULL|System|MTun|InLoop|BV1|mcast|test|pim|TEST)',
      table: true,
      derive: true,
      index_oid: 'IF-MIB::ifName',
      metric_type: 'snmp_if_traffic_tx'
    },
    {
      name: 'Interface RX Unicast Frames',
      oid: 'IF-MIB::ifHCInUcastPkts',
      excludes: '^(802|VI|Vl|Vi|Se|Lo|Nu|Tu|Vo|Vt|Aux|Console|NULL|System|MTun|InLoop|BV1|mcast|test|pim|TEST)',
      table: true,
      derive: true,
      index_oid: 'IF-MIB::ifName',
      metric_type: 'snmp_if_ucast_rx'
    },
    {
      name: 'Interface TX Unicast Frames',
      oid: 'IF-MIB::ifHCOutUcastPkts',
      excludes: '^(802|VI|Vl|Vi|Se|Lo|Nu|Tu|Vo|Vt|Aux|Console|NULL|System|MTun|InLoop|BV1|mcast|test|pim|TEST)',
      table: true,
      derive: true,
      index_oid: 'IF-MIB::ifName',
      metric_type: 'snmp_if_ucast_tx'
    },
    {
      name: 'Interface RX Multicast Frames',
      oid: 'IF-MIB::ifHCInMulticastPkts',
      excludes: '^(802|VI|Vl|Vi|Se|Lo|Nu|Tu|Vo|Vt|Aux|Console|NULL|System|MTun|InLoop|BV1|mcast|test|pim|TEST)',
      table: true,
      derive: true,
      index_oid: 'IF-MIB::ifName',
      metric_type: 'snmp_if_mcast_rx'
    },
    {
      name: 'Interface TX Multicast Frames',
      oid: 'IF-MIB::ifHCOutMulticastPkts',
      excludes: '^(802|VI|Vl|Vi|Se|Lo|Nu|Tu|Vo|Vt|Aux|Console|NULL|System|MTun|InLoop|BV1|mcast|test|pim|TEST)',
      table: true,
      derive: true,
      index_oid: 'IF-MIB::ifName',
      metric_type: 'snmp_if_mcast_tx'
    },
    {
      name: 'Interface RX Broadcast Frames',
      oid: 'IF-MIB::ifHCInBroadcastPkts',
      excludes: '^(802|VI|Vl|Vi|Se|Lo|Nu|Tu|Vo|Vt|Aux|Console|NULL|System|MTun|InLoop|BV1|mcast|test|pim|TEST)',
      table: true,
      derive: true,
      index_oid: 'IF-MIB::ifName',
      metric_type: 'snmp_if_bcast_rx'
    },
    {
      name: 'Interface TX Broadcast Frames',
      oid: 'IF-MIB::ifHCOutBroadcastPkts',
      excludes: '^(802|VI|Vl|Vi|Se|Lo|Nu|Tu|Vo|Vt|Aux|Console|NULL|System|MTun|InLoop|BV1|mcast|test|pim|TEST)',
      table: true,
      derive: true,
      index_oid: 'IF-MIB::ifName',
      metric_type: 'snmp_if_bcast_tx'
    },
    {
      name: 'Interface RX Errors',
      oid: 'IF-MIB::ifInErrors',
      excludes: '^(802|VI|Vl|Vi|Se|Lo|Nu|Tu|Vo|Vt|Aux|Console|NULL|System|MTun|InLoop|BV1|mcast|test|pim|TEST)',
      table: true,
      derive: true,
      index_oid: 'IF-MIB::ifName',
      metric_type: 'snmp_if_err_rx'
    },
    {
      name: 'Interface TX Errors',
      oid: 'IF-MIB::ifOutErrors',
      excludes: '^(802|VI|Vl|Vi|Se|Lo|Nu|Tu|Vo|Vt|Aux|Console|NULL|System|MTun|InLoop|BV1|mcast|test|pim|TEST)',
      table: true,
      derive: true,
      index_oid: 'IF-MIB::ifName',
      metric_type: 'snmp_if_err_tx'
    },
    {
      name: 'Cisco: PPPoE Sessions',
      oid: 'SNMPv2-SMI::enterprises.9.9.194.1.1.1.0',
      excludes: '',
      table: false,
      derive: false,
      index_oid: '',
      metric_type: 'snmp_pppoe_sess'
    },
    {
      name: 'Cisco: Highwater PPPoE Sessions',
      oid: 'SNMPv2-SMI::enterprises.9.9.194.1.1.2.0',
      excludes: '',
      table: false,
      derive: false,
      index_oid: '',
      metric_type: 'snmp_pppoe_highwater'
    },
    {
      name: 'Cisco: Per-slot CPU Usage (1 min)',
      oid: 'SNMPv2-SMI::enterprises.9.9.109.1.1.1.1.7',
      excludes: '',
      table: true,
      derive: false,
      index_oid: 'SNMPv2-SMI::enterprises.9.9.109.1.1.1.1.2',
      metric_type: 'snmp_cpu'
    },
    {
      name: 'Cisco: IP Pool Used Addresses',
      oid: 'SNMPv2-SMI::enterprises.9.9.326.1.2.2.1.2.0',
      excludes: '',
      table: false,
      derive: false,
      index_oid: '',
      metric_type: 'snmp_ip_pool_used'
    },
    {
      name: 'Cisco: IP Pool Free Addresses',
      oid: 'SNMPv2-SMI::enterprises.9.9.326.1.2.2.1.1.0',
      excludes: '',
      table: false,
      derive: false,
      index_oid: '',
      metric_type: 'snmp_ip_pool_free'
    },
    {
      name: 'D-Link: CPU Usage',
      oid: 'SNMPv2-SMI::enterprises.171.12.1.1.6.2.0',
      excludes: '',
      table: false,
      derive: false,
      index_oid: '',
      metric_type: 'snmp_cpu'
    },
  ]
)
