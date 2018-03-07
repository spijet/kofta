# frozen_string_literal: true

module KOFTA
  class Backup
    # This method dumps current DB state into a file for backup purposes.
    # Returns a full path to backup file (so we can send it to user later).
    def self.write(type = 'full')
      filename = Time.now.strftime('%Y%m%dT%H%M%S%z') + '_kofta_' + type + '.rb'
      filepath = Rails.root.join('db', 'backups', filename)
      Rails.logger.info "Writing the #{type} backup to #{filepath}."

      models(type).each do |model|
        File.open(filepath, 'a') { |file| file.write "# #{model}:\n" }
        SeedDump.dump(model,
                      file: filepath, append: true,
                      exclude: %i[created_at updated_at])
      end
      filepath
    end

    def self.models(type)
      types = {
        'datatypes' => [Datatype],
        'devices' => [Device, Device::HABTM_Datatypes],
        'full' => [Device, Datatype, Device::HABTM_Datatypes]
      }
      types[type]
    end
  end
end
