namespace :db do
  namespace :init do
    puts "\n\nStarting :init"

    Dir.entries(File.expand_path('../../../db/init/', __FILE__)).each do |file|
      if file =~ /\.rb$/
        file.gsub! /\.rb/, ''
        task file.to_sym => :environment do
          require File.expand_path('../../../db/load_dsl.rb', __FILE__)
          require File.expand_path('../../../db/init/'+file+'.rb', __FILE__)
        end
      end
    end
  end
  
  task :export => :environment do
    puts "\n\nStarting :export"
    require File.expand_path('../../../lib/seeder.rb', __FILE__)
    
    filename = ENV['file']
    
    puts "Starting export for filename: #{filename}"
    s = Seeder.new
    s.export_to_file(filename)
  end
  
end