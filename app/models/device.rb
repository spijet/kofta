class Device < ActiveRecord::Base
  has_and_belongs_to_many :datatypes
  validates :devname, :address, :snmp_community, :query_interval, :city, :group, presence: true
  validates :devname, :address, uniqueness: true
  validates :query_interval, numericality: true

  after_initialize { default_values }

  before_save { backup_devices }
  before_destroy { backup_devices }

  def default_values
    if new_record?
      self.datatypes = Datatype.where(default: true)
    end
  end

  def backup_devices
    filename = 'devices_' + Time.now.strftime('%Y%m%d_%H%M%S') + '.rb'
    p "Backing up devices data to 'db/backups/#{filename}.'"
    SeedDump.dump(Device, file: "db/backups/#{filename}")
  end

end
