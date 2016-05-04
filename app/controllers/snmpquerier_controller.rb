class SnmpquerierController < ApplicationController
  def getinfo
    info = Hash.new
    manager = SNMP::Manager.new(:host => params[:host])
    info[:devname] = manager.get_value("1.3.6.1.2.1.1.1.0")
    info[:contact] = manager.get_value("1.3.6.1.2.1.1.4.0")
    manager.close
    render json: info.to_json
    rescue => e
      render plain: e.to_s.capitalize + "!", status: 422
  end
end
