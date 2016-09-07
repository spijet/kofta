class ExtrasController < ApplicationController
  require 'csv'
  def index
  end

  def import_devices
    uploaded_file = params[:file]
    csv_data = CSV.read(uploaded_file.tempfile)

    keys = csv_data.shift
    @data = csv_data.map { |row| Hash[keys.zip(row)] }
    @data.each do |device_data|
      new_device = Device.new(device_data.except("vendor"))
      new_device.save
    end
  end

  def import_metrics
  end

  def export_devices
    devices_hashes = Device.all.to_a.map {
      |a| a.attributes.except("created_at", "updated_at", "id")
    }
    csv_data = CSV.generate do |row|
      row << devices_hashes.first.keys
      devices_hashes.each do |hash|
        row << hash.values
      end
    end
    send_data csv_data, filename: "exported_devices.csv"
  end

  def export_metrics
  end
end
