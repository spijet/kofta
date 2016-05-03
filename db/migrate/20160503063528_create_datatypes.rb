class CreateDatatypes < ActiveRecord::Migration
  def change
    create_table :datatypes do |t|
      t.string :name
      t.string :oid
      t.string :excludes
      t.boolean :table
      t.string :index_oid

      t.timestamps null: false
    end
  end
end
