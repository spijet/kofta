require 'rufus-scheduler'

# Let's use the rufus-scheduler singleton
#
$query_scheduler = Rufus::Scheduler.new(lockfile: ".rufus-scheduler.lock")

def queue_fillup
  Device.all.each do |device|
    $query_scheduler.every("#{device.query_interval}s", tag: device.id ) do

      Rails.logger.info "Hello, it's #{Time.now}"
      Rails.logger.info "I'm gonna go and query #{device.address}, if you don't mind."
      Rails.logger.flush
      SnmpWorkerJob.perform_later(device)
    end
  end
end

if defined?(Rails::Server)
  queue_fillup
end
