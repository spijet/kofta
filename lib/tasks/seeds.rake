desc 'Import all seed files.'

namespace :db do
  task import_seeds: :environment do
    Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].each do |filename|
      puts "Importing seed file #{filename}."
      load(filename)
    end
  end
end
