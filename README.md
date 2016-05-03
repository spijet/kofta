# KOFTA
## KOllector For Tired Admins

This is an attempt to create an SNMP stats collector for various network devices.
I grew tired of Cacti, I hate Zabbix, and I think that Collectd could be actually better. I also hate non-BULK SNMPWALKs. So I'll check if I can do better.

Eventually it'll use:

* Ruby 2.3.x;
* Rails 4.2.6 or newer;
* Sidekiq 4+ (for spawning collectors);
* Sqlite for the internal DB;
* Redis for Sidekiq operations;
* Net::SNMP for stat collection;
* InfluxDB::Client for DB connections;
