class AddDefaultToDatatypes < ActiveRecord::Migration
  def change
    add_column :datatypes, :default, :boolean
  end
end
