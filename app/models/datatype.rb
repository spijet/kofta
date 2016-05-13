class Datatype < ActiveRecord::Base
  has_and_belongs_to_many :devices
  validates :name, :oid, :metric_type, presence: true
  validates :name, :oid, uniqueness: true
  validates :index_oid, presence: true, if: :is_table?
  validates :index_oid, :excludes, absence: true, unless: :is_table?

  def is_table?
    table == true
  end
end
