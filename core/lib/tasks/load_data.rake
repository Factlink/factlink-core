require File.expand_path('../../../db/load_dsl.rb', __FILE__)

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
  namespace :init do

    Dir.entries(File.expand_path('../../../db/init/', __FILE__)).each do |file|
      if file =~ /\.rb$/
        file.gsub! /\.rb/, ''
        task file.to_sym => :environment do
          require File.expand_path('../../../db/init/'+file+'.rb', __FILE__)
          puts "Imported #{file} succesfully"
        end
      end
      
      doMagic
      
    end

    task :list do
      puts "You can load the following initial datasets (with db:init:<dataset>):"
      Dir.entries(File.expand_path('../../../db/init/', __FILE__)).each do |file|
        if file =~ /\.rb$/
          file.gsub! /\.rb$/, ''
          puts file
        end
      end
    end
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
        Fact.all.each do |fact|
          f.write(export_fact(fact))
          puts "."
        end

        FactRelation.all.each do |fact_relation|
          f.write(export_fact_relation(fact_relation))
          puts "."
        end
      end
    end
    
    puts "Exported succesfully"
    puts "Your export was saved to #{file}"
  end

  task :help do
    puts "\n############################"
    puts "# Factlink Database Seeder #\n\n"
    puts "The following commands are available:\n\n"
    puts "rake db:seed\t\t\t# Truncate database and seed with default users"
    puts "rake db:export file=filename\t# Exports the current database"
    puts "rake db:init:list\t\t# Lists all available seeds"
    puts "rake db:init:filename\t\t# Import the dump to the database"
    # puts "rake db:clean\t\t\t# Truncates the database"
    puts "rake db:help\t\t\t# Show this help file\n\n"
  end

end