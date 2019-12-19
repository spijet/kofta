source 'https://rubygems.org'
ruby '>= 2.3.0', '< 2.7'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~>4.2'

# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~>1.3', '< 1.4'

# Add support for DB dumps.
gem 'seed_dump'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use Puma app server
gem 'puma'

# Use MessagePack to pack data into strings (for Redis).
gem 'msgpack-rails'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Turbolinks also makes jQuery work like shit.
gem 'jquery-turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# Require SNMP Gem for SNMP functions
gem 'snmp', '~> 1.2'

# This gem provides InfluxDB connection and functions:
gem 'influxdb', '0.3.10'

# Include Ping functions:
gem 'net-ping'

# Sidekiq for queue management
gem 'sidekiq', '~> 4'
# if you require 'sinatra' you get the DSL extended to Object
gem 'sinatra', require: nil

# Rufus scheduler for recurrent tasks.
gem 'rufus-scheduler'

# We will use Bulma for SCSS styling.
#  That may change in the future.
gem 'bulma-rails', '~> 0.6.1'
# Also, use Font Awesome icons (for some parts of the UI).
gem 'font-awesome-sass', '~> 4.7.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end
