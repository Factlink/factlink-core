# commented out, otherwise screenshots are made in tests where this
# makes no sense, also seems to slow down the (old) unit-tests/integration tests
# (non acceptance tests)

# before uncommenting, please make sure that bundle exec rspec spec does not
# execute this file

# ENV["RAILS_ENV"] ||= 'test'
# require File.expand_path("../../../config/environment", __FILE__)
# require 'rspec/rails'
# require 'capybara/rspec'
# require 'capybara/email/rspec'
# require 'headless'
# require 'acceptance_helper'

# describe 'capybara and devise are broken', type: :request do
#   it 'action_mailer default url should change when visiting a page' do
#     # Something changes the config option, so that the e-mails don't contain correct links.
#     # Depending on which capybara driver is used, it changes in an example.org or :56781.
#     # This error is triggered when enabling javascript either by js: true (rack test) or using webkit.
#     initialValue = FactlinkUI::Application.config.action_mailer.default_url_options[:host]

#     visit "/"

#     initialValue.should_not equal FactlinkUI::Application.config.action_mailer.default_url_options[:host]
#   end
# end
