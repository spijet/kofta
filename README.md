# KOFTA
## KOllector For Tired Admins

---

# Description
This is an attempt to create an SNMP stats collector for various network devices.
I grew tired of Cacti, I hate Zabbix, and I think that Collectd could do its job
better. I also hate non-BULK SNMPWALKs.

Enter **KOFTA** — the piece of Rails code that was born with a single purpose: To
replace Collectd and to feed InfluxDB with data, with style.

## State
As of 2016-May-11, the app is somewhat functional. InfluxDB connection and data sending is working, Web UI now has something that looks like a menu, Devices and Datatypes views are mostly done, repeating parts are moved to layout and shared partials. Still has to implement dynamic scheduling in a way that every device gets its own recurring SNMP task. Just a little bit more and it's ready.

## License
This software is (not yet) released under the [MIT license](https://opensource.org/licenses/MIT).

## Magic used
* Ruby 2.2 is required (2.3.x is recommended, JRuby would be ideal, but isn't tested yet);
* Rails 4.2.6 or newer;
* Sidekiq 4+ (for spawning collectors);
* Redis (required for Sidekiq, 3.0.3 or newer is best);
* Sqlite (for internal DB);
* Net::SNMP gem for stat collection;
* InfluxDB::Client for DB connections;
* Bulma CSS for Web UI.

---

# Installation
## Getting the code and preparing for first start:
* `git clone <repo_URL> <app_dir>`;
* `cd <app_dir>`;
* `bundle install`;
* To initialize database: `rake db:setup`;
   This will init the DB with basic stuff (like, basic set of metrics that can be used to query devices)
* Start Redis (use your OS/Distro's way of starting services for this);
* Start Sidekiq with `bundle exec sidekiq`;
* If you want to test/develop it: `rails server`;
* If you want to see how it'll look/behave in real-er world: `RAILS_ENV=production rails server`.
