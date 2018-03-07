# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Check if running as a Rake task:
RAKE_ENV = ENV['RACK_ENV'].blank? || ENV['RAILS_ENV'].blank? || !(ENV.inspect.to_s =~ /worker/i).blank?

# Initialize the Rails application.
Rails.application.initialize!
