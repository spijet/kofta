require 'rufus-scheduler'

# Let's use the rufus-scheduler singleton
#
$query_scheduler = Rufus::Scheduler.new(lockfile: '.rufus-scheduler.lock')

def queue_fillup
  return false if $query_bootstrapped
  Device.all.each do |device|
    $query_scheduler.every("#{device.query_interval}s", tag: device.id) do
      Rails.logger.info format('Hello, it´s %s.', Time.now.to_s)
      Rails.logger.info format('I´m gonna go and query %s from %s.',
                               device.address, device.city)
      Rails.logger.flush
      SnmpWorkerJob.perform_later(device)
    end
  end
  $query_bootstrapped = true
end

queue_fillup if defined?(Rails::Server) || File.split($PROGRAM_NAME).last == 'puma'
