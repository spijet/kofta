require 'rufus-scheduler'

# Let's use the rufus-scheduler singleton
#
$query_scheduler = Rufus::Scheduler.new(lockfile: '.rufus-scheduler.lock')

def queue_fillup
  Device.all.each do |device|
    $query_scheduler.every("#{device.query_interval}s", tag: device.id) do
      Rails.logger.info "Hello, it's #{Time.now}"
      Rails.logger.info "I'm gonna go and query #{device.address} from #{device.city}."
      Rails.logger.flush
      SnmpWorkerJob.perform_later(device)
    end
  end unless $query_bootstrapped
  $query_bootstrapped = true
end

queue_fillup if defined?(Rails::Server) || File.split($PROGRAM_NAME).last == 'puma'
