
def get_file(file)
  # file is frozen string, can't be modified: so duplicate
  file_name = file.dup

  unless File.extname(file_name) == ".rb"
    file_name << ".rb"
  end

  dump_dir = File.expand_path("#{Rails.root}/" + "db/init")
  return File.join(dump_dir, file_name)
end

namespace :db do
  task :truncate => :environment do
    require File.expand_path('../../../db/truncate.rb', __FILE__)
    truncate(:users => :truncate)
  end

  task :truncate_keep_users => :environment do
    require File.expand_path('../../../db/truncate.rb', __FILE__)
    truncate(:users => :keep)
  end

  task :export, [:filename] => [:environment, :migrate] do |task, args|
    File.open(args[:filename], 'w') do |file|
      file.write Export.new.export
    end
  end

  task :import, [:filename] => [:environment, :truncate, :migrate] do |task, args|
    require File.expand_path(args[:filename], Dir.pwd)
  end

  task :help do
    message = <<-eos

      ############################
      # Factlink Database Seeder #
      ############################

      The following commands are available:

      rake db:truncate              # Truncate database
      rake db:truncate_keep_users   # Truncate database, but keep the users
      rake db:export[dump.rb]       # Export the database to dump.rb
      rake db:import[dump.rb]       # Import the database from dump.rb
      rake db:help                  # Show this help file

    eos
    puts message.gsub(/^ */,'')
  end

end
