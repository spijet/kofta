# KOFTA
## KOllector For Tired Admins

### Description
This is an attempt to create an SNMP stats collector for various network devices.
I grew tired of Cacti, I hate Zabbix, and I think that Collectd could be actually better. I also hate non-BULK SNMPWALKs. So I'll check if I can do better.

### Magic used
Eventually it'll use:

* Ruby 2.3.x;
* Rails 4.2.6 or newer;
* Sidekiq 4+ (for spawning collectors);
* Sqlite for the internal DB;
* Redis for Sidekiq operations;
* Net::SNMP for stat collection;
* InfluxDB::Client for DB connections;

### Installation

* `git clone <repo_URL> <app_dir>`;
* `cd <app_dir>`;
* `bundle install`;
* If you want to test/develop it: `rails server`;
* If you want to see how it'll look/behave in real-er world: `RAILS_ENV=production rails server`.
