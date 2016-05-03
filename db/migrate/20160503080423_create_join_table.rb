class CreateJoinTable < ActiveRecord::Migration
  def change
    create_join_table :devices, :datatypes do |t|
      t.index [:device_id, :datatype_id]
      t.index [:datatype_id, :device_id]
    end
  end
end
