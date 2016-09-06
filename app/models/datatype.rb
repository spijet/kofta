class Datatype < ActiveRecord::Base
  has_and_belongs_to_many :devices
  validates :name, :oid, :metric_type, presence: true
  validates :name, :oid, uniqueness: true
  validates :index_oid, presence: true, if: :is_table?
  validates :index_oid, :excludes, absence: true, unless: :is_table?

  before_save { backup_datatypes }
  before_destroy { backup_datatypes }

  def backup_datatypes
    filename = 'datatypes_' + Time.now.strftime('%Y%m%d_%H%M%S') + '.rb'
    p "Backing up datatypes data to 'db/backups/#{filename}.'"
    SeedDump.dump(Datatype, file: "db/backups/#{filename}")
  end

  def is_table?
    table
  end
end
