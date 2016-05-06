class AddQueryIntervalToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :query_interval, :integer
  end
end
