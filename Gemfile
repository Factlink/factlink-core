source 'https://rubygems.org'
source 'https://rails-assets.org'

ruby '2.1.7'

gem 'rails', '4.2.5' # this is too important to update automatically

gem 'rails_12factor', '~> 0.0.2', groups: [:staging, :production]

gem 'protected_attributes', '~> 1.1.3'
gem 'rake', '~> 10.4.2', require: false

gem 'secure_headers', '~> 1.2.0'

# Postgres
gem 'pg', '~> 0.18.2'
gem 'pg_search', '~> 1.0.4'

gem 'unicorn', '~> 4.9.0', groups: [:staging, :production]

gem 'pavlov', github: 'Factlink/pavlov'

# Simple value objects
gem 'strict_struct', '~> 1.0'

gem 'sucker_punch', '~> 1.5.1'

# User authentication and authorization
gem 'devise', '~> 3.5.2'
gem 'cancan', '~> 1.6.10'

# social connections
gem 'omniauth-facebook', '~> 2.0.1'
gem 'omniauth-twitter', '~> 1.2.1'

# Used for deauthorizing Facebook
gem 'httparty', '~> 0.13.1'

#browser detection
gem 'browser', '~> 1.0'

# one of our own gems, to normalize urls
gem 'url_normalizer', github: 'Factlink/url_normalizer'

gem 'roadie', '~> 2.4.3'

gem 'appsignal'
gem 'ohnoes', github: 'markijbema/ohnoes'

# Asset pipeline
gem 'uglifier', '~> 2.5'
gem 'therubyracer', '~> 0.12.1'
gem 'coffee-script', '~> 2.4.1'
gem 'sass-rails', '~> 4.0.3'

# Assets
gem 'jquery-rails', '~> 3.1.2' # this is 1.11.0; not jquery 2.0 yet.  jquery-migrate claims 2.0 would be safe.
gem 'jquery-rails-cdn', '~> 1.0.3'
gem 'rails-assets-backbone', '~> 1.1.2' # beware, backbone does not use semver!
gem 'rails-assets-react', '~> 0.11.0'
gem 'rails-assets-react.backbone', '~> 0.3.1'
gem 'rails-assets-jquery-autosize', '~> 1.18.8'
gem 'rails-assets-tether', '~> 1.1.0'
gem 'rails-assets-factlink-js-library', '~> 0.2.0'

group :development do
  # we allow all development gems to update always
  # since we will notice when this fails

  # mesa want speed:
  gem 'turbo_dev_assets'
  gem 'pry', '~> 0', require: false

  #for static files serving
  gem 'rack', '~> 1.6.0'
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

  gem "codeclimate-test-reporter", require: false
end

group :test, :development do # TODO why is there a :development here?
  gem 'konacha', '~> 3.0'

  gem 'poltergeist', '~> 1.6.0', require: false
  gem 'capybara', '~> 2.1', require: false
  gem 'capybara-screenshot', '~> 1.0.11', require: false
  gem 'capybara-email', '~> 2.0', require: false

  gem 'sinon-chai-rails', '~> 1.0'
  gem 'sinon-rails', '~> 1.4'

  gem 'dotenv-rails', '~> 2.0.2'
end
