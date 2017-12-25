require 'influxdb'

INFLUX_CONFIG = YAML.load(ERB.new(File.read(Rails.root.join('config', 'influx.yml'))).result)[Rails.env]
