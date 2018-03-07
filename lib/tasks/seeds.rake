desc 'Import all seed files.'

Rake::Task['db:seed'].clear

namespace :db do
  task seed: :environment do
    Rake::Task['db:abort_if_pending_migrations'].invoke
    Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].each do |filename|
      puts "Importing seed file #{filename}."
      load(filename)
    end
  end
end
