if Object.const_defined?(:Rails)
  require_relative 'spec_helper.rb'
else
  require "rubygems"
  require "bundler/setup"
  require 'ohm'
  require 'active_model'
  require 'canivete'

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  class Rails
    def self.env
      'test'
    end
  
    def self.root
      Pathname.new(File.expand_path('../../', __FILE__))
    end  
  end


  require File.expand_path('../../app/ohm-models/our_ohm.rb', __FILE__)
  require File.expand_path('../../config/initializers/redis.rb', __FILE__)



  RSpec.configure do |config|
    config.mock_with :rspec


    config.before(:each) do
      Ohm.flush
    end 

    config.after(:suite) do
      Ohm.flush
    end

  end
end