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
As of 2016-Aug-01, the app is almost fully functional. InfluxDB connection and data sending works well, Web UI is almost done, repeating parts are moved to layout and shared partials.
Dynamic query schedule is implemented using `rufus-scheduler`. Also, now it doesn't trigger jobs when Rails console is started, jobs start only when Rails App Server (or Puma) is up.
SNMP queries (in per-device workers) are parallelized using a thread pool. Derive metrics are handled internally, with Redis as intermediate data storage.
Current repo also includes SMF manifests for Solaris/Illumos hosts.

## TODO
* ~~Make Rufus behave and to run only one scheduling thread per app instance~~ Done in c34e097;
* **Make SNMP Querier tasks multithreaded (to make it faster for bigger tables and/or remote nodes)** -- partially implemented in 9e00b5d, moved from "one thread per table" model to a thread pool (4 threads for now) in 6e854fe;
* ~~Add some more metrics to `seeds.rb`~~: SNMP errors added in ffa0792; even more metrics in 6494fe3;
* ~~Add non-SNMP performance metrics: device response time (ping) and device query time (query job duration)~~ Done in f51bca8, reports time as milliseconds;
* Finish Web UI;
* Write some docs and provide an example visualizing setup (Grafana Dashboard JSON);
* Add JRuby support for some multithreaded GC'ed quality time;
* Minimize memory consumption: since Sidekiq uses threads for workers, MRI sometimes fails to free memory previously used by now-destroyed worker. Some of my tries include: 0a1d147 393777e f3b7808 ae85036 dac178b 197714c 895f542 c418649. All suggestions are welcome!

## License
This software is released under the [MIT license](https://opensource.org/licenses/MIT).

## Magic used
* Ruby 2.2 is required (2.3.x is recommended, JRuby would be ideal, but isn't tested yet);
* Rails 4.2.6 or newer;
* [Sidekiq](https://github.com/mperham/sidekiq) 4+ as ActiveJob queue manager, made by [Mike Perham](https://github.com/mperham);
* Redis (required for Sidekiq, 3.0.3 or newer is best);
* Sqlite (for internal DB);
* [Ruby-SNMP](https://github.com/hallidave/ruby-snmp) gem for stat collection, made by [Dave Halliday](https://github.com/hallidave);
* [InfluxDB::Client](https://github.com/influxdata/influxdb-ruby) for DB connections, made and maintained by [Todd Persen](https://github.com/toddboom) and [Dominik Menke](https://github.com/dmke);
* [Bulma CSS](http://bulma.io/) for Web UI, made by [Jeremy Thomas](https://github.com/jgthms).

---

# Installation
## Getting the code and preparing for first start:
* `git clone <repo_URL> <app_dir>`;
* `cd <app_dir>`;
* `bundle install`;
* To initialize database: `rake db:setup`;
   This will init the DB with basic stuff (like, basic set of metrics that can be used to query devices)
* If you want to restore from a seed-like backup:
   Copy needed backup files to `db/seeds`;
   Do `rake db:import_seeds`.
* Start Redis (use your OS/Distro's way of starting services for this);
* Start Sidekiq with `bundle exec sidekiq`;
* If you want to test/develop it: `rails server`;
* If you want to see how it'll look/behave in real-er world: `RAILS_ENV=production rails server`.
