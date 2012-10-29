
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

  task :export => :environment do
    filename = ENV['file']

    if filename.nil? or filename.blank?
      puts "A file name is required. Usage: rake db:export file=filename"
      next
    end

    file = get_file(filename)

    if File.exists?(file) or filename == 'list'
      puts "File '#{filename}' already exists. Please choose another file name."
      next
    else

      # Dump the exports to the file
      File.open(file, 'w') do |f|
        FactGraph.export(f, verbose: true)
      end
    end

    puts "Exported succesfully"
    puts "Your export was saved to #{file}"
  end

  task :help do
    message = <<-eos

      ############################
      # Factlink Database Seeder #
      ############################

      The following commands are available:

      rake db:truncate              # Truncate database
      rake db:truncate_keep_users   # Truncate database, but keep the users
      rake db:export file=filename  # Exports the current database
      rake db:init:list             # Lists all available seeds
      rake db:init:filename         # Import the dump to the database
      rake db:help                  # Show this help file

    eos
    puts message.gsub(/^ */,'')
  end

end
