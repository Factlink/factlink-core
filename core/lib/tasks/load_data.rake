dump_dir = File.expand_path("#{Rails.root}/" + "db/init")

def get_file(file)
  # file is frozen string, can't be modified: so duplicate
  file_name = file.dup
  
  unless File.extname(file_name) == ".rb"
    file_name << ".rb"
  end
  
  return File.join(dump_dir, file_name)
end


namespace :db do
  namespace :init do

    Dir.entries(File.expand_path('../../../db/init/', __FILE__)).each do |file|
      if file =~ /\.rb$/
        file.gsub! /\.rb/, ''
        task file.to_sym => :environment do
          require File.expand_path('../../../db/load_dsl.rb', __FILE__)
          require File.expand_path('../../../db/init/'+file+'.rb', __FILE__)
        end
      end
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
    require File.expand_path('../../../lib/seeder.rb', __FILE__)
    
    filename = ENV['file']

    file = get_file(file_name)

    if File.exists?(file)
      puts "File #{file_name} already exists. Please choose another file name."
      return nil
    else

      # Dump the exports to the file
      File.open(file, 'w') do |f|      
        Fact.all.each do |fact|
          f.write(export_fact(fact))
        end

        FactRelation.all.each do |fact_relation|
          f.write(export_fact_relation(fact_relation))
        end
      end
    end
  end

  task :help do
    puts "# Factlink Database Seeder #\n\n"
    puts "The following commands are available:\n\n"
    puts "rake db:seed\t\t\t# Seeds the regular database"
    puts "rake db:export file=filename\t# Exports the current database"
    puts "rake db:init:list\t\tLists all available seeds"
    puts "rake db:init:filename\t# Import the dump to the database"
    puts "rake db:clean\t\t\t# Truncates the database"
    puts "rake db:help\t\t\t# Show this help file\n\n"
  end

end

# rake db:init:baronie