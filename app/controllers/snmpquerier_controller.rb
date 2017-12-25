class SnmpquerierController < ApplicationController
  def getinfo
    manager = SNMP::Manager.new(params.slice(:host, :community).symbolize_keys)
    info = {
      name: manager.get_value('SNMPv2-MIB::sysName.0'),
      location: manager.get_value('SNMPv2-MIB::sysLocation.0'),
      contact: manager.get_value('SNMPv2-MIB::sysContact.0'),
      description: manager.get_value('SNMPv2-MIB::sysDescr.0')
    }
    manager.close
    render json: info.to_json
  rescue => e
    render plain: e.to_s.capitalize + '!', status: 422
  end
end
