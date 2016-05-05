# KOFTA
## KOllector For Tired Admins

---

# Description
This is an attempt to create an SNMP stats collector for various network devices.
I grew tired of Cacti, I hate Zabbix, and I think that Collectd could do its job
better. I also hate non-BULK SNMPWALKs.

Enter **KOFTA**: This piece of Rails code was born with a single purpose: To
replace Collectd and to feed InfluxDB with data, with style.

## License
This software is (not yet) released under the [MIT license](https://opensource.org/licenses/MIT).

## Magic used
Eventually it'll use:

* Ruby 2.3.x;
* Rails 4.2.6 or newer;
* Sidekiq 4+ (for spawning collectors);
* Sqlite for the internal DB;
* Redis for Sidekiq operations;
* Net::SNMP for stat collection;
* InfluxDB::Client for DB connections;

---

# Installation
## Getting the code and preparing for first start:
* `git clone <repo_URL> <app_dir>`;
* `cd <app_dir>`;
* `bundle install`;
* To initialize database: `rake db:setup`;
   This will init the DB with basic stuff (like, basic set of metrics that can be used to query devices)
* If you want to test/develop it: `rails server`;
* If you want to see how it'll look/behave in real-er world: `RAILS_ENV=production rails server`.
