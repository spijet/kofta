class AddDeriveToDatatypes < ActiveRecord::Migration
  def change
    add_column :datatypes, :derive, :boolean
  end
end
