class Datatype < ActiveRecord::Base
  has_and_belongs_to_many :devices
  validates :name, :oid, :table, :metric_type, presence: true
  validates :name, :oid, uniqueness: true
  if :table
    validates :index_oid, presence: true
  else
    validates :index_oid, :excludes, abscense: true
  end
end
