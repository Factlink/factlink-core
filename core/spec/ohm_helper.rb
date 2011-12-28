if Object.const_defined?(:Rails)
  require_relative 'spec_helper.rb'
else
  require "rubygems"
  require "bundler/setup"
  require 'ohm'
  require 'active_model'
  require 'andand'
  require 'mock_redis'

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  class Rails
    def self.env
      'test'
    end

    def self.root
      Pathname.new(File.expand_path('../../', __FILE__))
    end

    module VERSION
      MAJOR=3
    end
  end

  Ohm.redis = MockRedis.new

  require_relative '../app/ohm-models/our_ohm.rb'

  RSpec.configure do |config|
    config.mock_with :rspec

    config.before(:each) do
      Ohm.flush
    end
  end
end