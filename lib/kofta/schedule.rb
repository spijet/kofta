# coding: utf-8
# frozen_string_literal: true

# This file is a part of KOFTA SNMP Collector.
module KOFTA
  class Schedule
    @s = Rufus::Scheduler.s(lockfile: '.rufus-scheduler.lock')

    # Check if device already is in the queue.
    def self.has?(device)
      !@s.jobs(tag: device.id).empty?
    end

    def self.jobs(*args)
      @s.jobs(*args)
    end

    # Pre-format a message for Rails logger.
    def self.log(device, event)
      action = case event
               when :add then 'added to'
               when :del then 'removed_from'
               when :readd then 're-added to'
               when :exists then 'is already in the'
               end
      format('Device "%<name>s" (IP: %<address>s) %<action>s queue',
             name: device.devname,
             address: device.address,
             action: action)
    end

    # Add Device to queue.
    def self.add(device)
      if has?(device)
        Rails.logger.warn log(device, :exists)
      else
        @s.every("#{device.query_interval}s", tag: device.id) do
          SnmpWorkerJob.perform_later(device.id)
        end
        Rails.logger.info log(device, :add)
      end
      Rails.logger.flush
    end

    # Remove Device from queue.
    def self.del(device)
      @s.jobs(tag: device.id).each do |job|
        job.unschedule
        Rails.logger.info log(device, :del)
        Rails.logger.flush
      end
    end

    # Re-add device to queue (i.e. to change its query interval).
    def self.readd(device)
      Rails.logger.info log(device, :readd)
      del(device)
      add(device)
    end

    # Bootstrap the queue.
    def self.fill
      Rails.logger.info 'Bootstrapping query queue…'
      Device.find_each do |device|
        add(device)
      end
      Rails.logger.info 'Done!'
    end
  end
end
