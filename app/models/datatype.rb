class Datatype < ActiveRecord::Base
  has_and_belongs_to_many :devices, -> { uniq }
  validates :name, :oid, :metric_type, presence: true
  validates :name, :oid, uniqueness: true
  validates :index_oid, presence: true, if: :table?
  validates :index_oid, :excludes, absence: true, unless: :table?

  def backup_datatypes
    # Check if running as a Rake task:
    unless ENV['RACK_ENV'].blank? || ENV['RAILS_ENV'].blank? ||
           !(ENV.inspect.to_s =~ /worker/i).blank?
      KOFTA::Backup.write('datatypes')
    end
  end

  before_create  { backup_datatypes }
  before_update  { backup_datatypes }
  before_destroy { backup_datatypes }
end
