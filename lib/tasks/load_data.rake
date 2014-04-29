
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
  task :export, [:filename] => [:environment, :migrate] do |task, args|
    File.open(args[:filename], 'w') do |file|
      file.write Export.new.export
    end
  end

  task :import, [:filename] => [:environment, :reset, :migrate] do |task, args|
    require File.expand_path(args[:filename], Dir.pwd)
  end

  task :help do
    message = <<-eos

      ############################
      # Factlink Database Seeder #
      ############################

      The following commands are available:

      rake db:reset                 # Reset database
      rake db:export[db/dump.rb]    # Export the database to db/dump.rb
      rake db:import[db/dump.rb]    # Import the database from db/dump.rb
      rake db:help                  # Show this help file

    eos
    puts message.gsub(/^ */,'')
  end

end
