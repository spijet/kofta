require 'rufus-scheduler'

# Let's use the rufus-scheduler singleton
#
s = Rufus::Scheduler.singleton


# Stupid recurrent task...
#
Device.all.each do |device|
  s.every "#{device.query_interval}s" do

    Rails.logger.info "Hello, it's #{Time.now}"
    Rails.logger.info "I'm gonna go and query #{device.address}, if you don't mind."
    Rails.logger.flush
    SnmpWorkerJob.perform_later(device)
  end
end
