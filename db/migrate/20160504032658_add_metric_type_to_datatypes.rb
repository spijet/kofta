class AddMetricTypeToDatatypes < ActiveRecord::Migration
  def change
    add_column :datatypes, :metric_type, :string
  end
end
