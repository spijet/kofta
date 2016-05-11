class Device < ActiveRecord::Base
  has_and_belongs_to_many :datatypes
  validates :devname, :address, :snmp_community, :query_interval, :city, :group, presence: true
  validates :devname, :address, uniqueness: true
  validates :query_interval, numericality: true

end
