require 'influxdb'

INFLUX_CONFIG = YAML.load_file(Rails.root.join('config', 'influx.yml'))[Rails.env]
