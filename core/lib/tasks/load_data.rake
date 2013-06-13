
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

  task :init => [:environment,:migrate] do
    require File.expand_path('../../../db/init.rb', __FILE__)
    puts "Imported #{file} succesfully"
  end

  task :help do
    message = <<-eos

      ############################
      # Factlink Database Seeder #
      ############################

      The following commands are available:

      rake db:truncate              # Truncate database
      rake db:truncate_keep_users   # Truncate database, but keep the users
      rake db:init                  # Import the dump to the database
      rake db:help                  # Show this help file

    eos
    puts message.gsub(/^ */,'')
  end

end
