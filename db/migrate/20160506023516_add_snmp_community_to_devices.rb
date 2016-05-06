class AddSnmpCommunityToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :snmp_community, :string
  end
end
