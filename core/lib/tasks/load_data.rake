namespace :db do
  task :some_facts => :environment do
    require File.expand_path('../../../db/load_dsl.rb', __FILE__)
    require File.expand_path('../../../db/some_facts.rb', __FILE__)
  end
  task :listall do
    Dir.entries(File.expand_path('../../../db/', __FILE__)).each do |file|
      puts file
    end
  end
end