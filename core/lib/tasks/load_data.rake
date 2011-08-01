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
  end
end