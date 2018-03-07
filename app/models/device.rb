class Device < ActiveRecord::Base
  has_and_belongs_to_many :datatypes, -> { uniq }
  validates :devname, :address, :snmp_community,
            :query_interval, :city, :group, presence: true
  validates :devname, :address, uniqueness: true
  validates :query_interval, numericality: true

  def backup_devices
    # Check if running as a Rake task:
    unless ENV['RACK_ENV'].blank? || ENV['RAILS_ENV'].blank? ||
           !(ENV.inspect.to_s =~ /worker/i).blank?
      KOFTA::Backup.write('devices')
    end
  end

  before_create  { backup_devices }
  before_update  { backup_devices }
  before_destroy { backup_devices }
end
