source 'http://rubygems.org'
source 'https://rails-assets.org'

ruby '2.1.1'

gem 'dotenv-rails', groups: [:development, :test]

gem 'rails', '4.1.0' # this is too important to update automatically

gem 'rails_12factor', require: false
gem 'passenger', '~> 4.0.41', require: false

gem 'protected_attributes', '~> 1.0.3'
gem 'rake', '~> 10.1.0', require: false

# Postgres
gem 'pg'
gem 'pg_search', "~> 0.7.3"

gem 'pavlov', github: 'Factlink/pavlov'

# Simple value objects
gem 'strict_struct', '= 0.0.4' # by @markijbema, ask him if he pushed breaking changes in new versions

gem 'multi_json', '~> 1.7'

gem 'sucker_punch'

# Everyone loves JSON
gem 'json', '~> 1.8'

# User authentication and authorization
gem 'devise', '~> 3.0.0'
gem 'cancan', '~> 1.6.10'

# social connections
gem 'omniauth-facebook', '~> 1.6.0'
gem 'omniauth-twitter', '~> 1.0.1'

gem 'httparty', '~> 0.13.0'

#browser detection
gem 'browser', '~> 0.4.1'

# one of our own gems, to normalize urls
gem 'url_normalizer', github: 'Factlink/url_normalizer'

gem 'capistrano', '~> 2.15', require: false
gem 'capistrano-ext', '~> 1.2.1',  require: false

gem 'roadie', '~> 2.4.3'

# Set X-Frame-Headers
gem 'rack-xframe-options', github: 'Factlink/rack-xframe-options'
gem 'rack-rewrite', '~> 1.3.3'

gem 'appsignal'
gem 'ohnoes', github: 'markijbema/ohnoes'

group :assets do
  gem 'uglifier', '~> 2.0'

  gem 'therubyracer', '~> 0.12.0'

  gem "coffee-script", '~> 2.2'

  gem 'jquery-rails', '~> 3.0' #this is 1.10.2; not jquery 2.0 yet.  jquery-migrate claims 2.0 would be safe.
  gem 'jquery-rails-cdn', '~> 1.0.1'

  gem "rails-assets-backbone", '~> 1.1.2' #beware, backbone does not use semver!

  gem "rails-assets-react"
  gem "rails-assets-react.backbone"
  gem "rails-assets-jquery-autosize"
  gem 'rails-assets-tether'
  gem 'rails-assets-factlink-js-library', '= 0.1.0'

  gem 'sprockets', '2.11.0'

  gem 'sass-rails', '~> 4.0.1'

  gem 'ckeditor_rails'
  gem 'sanitize'
end

group :development do
  # we allow all development gems to update always
  # since we will notice when this fails

  # mesa want speed:
  gem 'turbo_dev_assets'
  gem 'pry', '~> 0', require: false

  #for static files serving
  gem 'rack', '~> 1'
  gem 'thin', '~> 1'

  gem 'lograge', '~> 0'

  gem 'brakeman', '~> 2.0.0', require: false # upgrade awaiting sprockets upgrade awaiting rails 4
  gem 'rails_best_practices', '~> 1', require: false
  gem 'rubocop', require: false
  gem 'hub', '~> 1', require: false
  gem 'selenium', require: false
  gem 'selenium-webdriver', require: false
end

group :test do
  # we allow tests to upgrade everything but major
  gem 'rspec-rails', '~> 2.13'
  gem 'webmock', require:false
  gem 'factory_girl_rails', '~> 4.2'
  gem 'database_cleaner', '~> 1.0'

  gem 'oily_png', '~> 1.1'

  gem 'rb-fsevent', '~> 0.9.1'
  gem 'guard', '~> 2.0', require: false
  gem 'guard-rspec', '~> 4.0', require: false
  gem 'terminal-notifier-guard', '~> 1.5', require: false

  gem 'approvals', '~> 0' # not locked, since test will break if something goes wrong here
end

group :test, :development do # TODO why is there a :development here?
  # we allow tests to upgrade everything but major
  gem 'konacha', '~> 3.0'

  gem 'poltergeist', '~> 1.5', require: false
  gem 'capybara', '~> 2.1', require: false
  gem 'capybara-screenshot', '~> 0.3', require: false
  gem 'capybara-email', '~> 2.0', require: false

  gem 'sinon-chai-rails', '~> 1.0'
  gem 'sinon-rails', '~> 1.4'
  gem 'scss-lint', '~> 0.23'
end
