class SnmpquerierController < ApplicationController
  def getinfo
    info = Hash.new
    manager = SNMP::Manager.new(host: params[:host], community: params[:community])
    info[:name] = manager.get_value('SNMPv2-MIB::sysName.0')
    info[:location] = manager.get_value('SNMPv2-MIB::sysLocation.0')
    info[:contact] = manager.get_value('SNMPv2-MIB::sysContact.0')
    info[:description] = manager.get_value('SNMPv2-MIB::sysDescr.0')
    manager.close
    render json: info.to_json
    rescue => e
      render plain: e.to_s.capitalize + '!', status: 422
  end
end
