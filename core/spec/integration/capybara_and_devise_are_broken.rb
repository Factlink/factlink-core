ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara-webkit'
require 'capybara/email/rspec'
require 'headless'

describe 'capybara and devise are broken', type: :request do
  it 'action_mailer default url should change when visiting a page' do
    FactlinkUI::Application.config.action_mailer.default_url_options.class.send(:define_method,:[]) do |a|
      raise :hell
    end
    initialValue = FactlinkUI::Application.config.action_mailer.default_url_options[:host]

		visit "/"

  	initialValue.should_not equal FactlinkUI::Application.config.action_mailer.default_url_options[:host]
  end
end
