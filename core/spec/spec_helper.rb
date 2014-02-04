unless defined?(I_AM_ACCEPTANCE_SPEC_HELPER)

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'webmock/rspec'
require 'rubygems'
require 'database_cleaner'
require 'pavlov_helper'
require 'webmock'
require 'approvals/rspec'

I_AM_SPEC_HELPER = true

# Don't do web requests from tests
WebMock.disable_net_connect!(:allow_localhost => true)

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f|require f }

RSpec.configure do |config|
  # Exclude integration tests in normal suite
  config.filter_run_excluding type: :feature
  config.mock_with :rspec

  config.include FactoryGirl::Syntax::Methods
  config.include ControllerMethods, type: :controller

  config.include Devise::TestHelpers, type: :view
  config.include Devise::TestHelpers, type: :controller

  config.before(:suite) do
    ElasticSearch.create
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = "mongoid"
  end

  config.before(:each) do
    ElasticSearch.clean
    Ohm.flush
    DatabaseCleaner.clean
  end
end

Approvals.configure do |c|
  c.excluded_json_keys = {
    id: /\Aid\z/,
    timestamp: /\Atimestamp\z/,
    created_at: /\Acreated_at\z/
  }
end

# Speed improvements in password hashing
module Devise
  module Models
    module DatabaseAuthenticatable
      protected
        def password_digest(password)
          password
        end

        def valid_password?(password)
          return false if encrypted_password.blank?
          encrypted_password == password
        end
    end
  end
end
Devise.setup do |config|
  # https://github.com/plataformatec/devise/wiki/Speed-up-your-unit-tests
  config.stretches = 0
end

end # don't load if acceptance_helper is loaded
