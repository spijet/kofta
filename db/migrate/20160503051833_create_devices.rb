class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :devname
      t.string :city
      t.string :contact
      t.string :group
      t.string :address

      t.timestamps null: false
    end
  end
end
