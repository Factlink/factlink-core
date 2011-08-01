namespace :db do
  task :some_facts => :environment do
    require File.expand_path('../../../db/some_facts.rb', __FILE__)
  end
end