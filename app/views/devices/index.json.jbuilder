json.array!(@devices) do |device|
  json.extract! device, :id, :devname, :city, :contact, :group, :address
  json.url device_url(device, format: :json)
end
