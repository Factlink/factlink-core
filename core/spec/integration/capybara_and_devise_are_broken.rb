ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara-webkit'
require 'capybara/email/rspec'
require 'headless'
require 'integration_helper'

describe 'capybara and devise are broken', type: :request do
  it 'action_mailer default url should change when visiting a page' do
    initialValue = FactlinkUI::Application.config.action_mailer.default_url_options[:host]

		visit "/"

  	initialValue.should_not equal FactlinkUI::Application.config.action_mailer.default_url_options[:host]
  end
end
