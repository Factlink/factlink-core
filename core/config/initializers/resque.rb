require 'yaml'
rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = ENV['RAILS_ENV'] || 'development'

resque_config = YAML.load_file(rails_root + '/config/resque.yml')
Resque.redis = resque_config[rails_env]

if defined?(Rails)
  Resque.inline = Rails.env.test?
end


require 'resque/failure/airbrake'
Resque::Failure::Airbrake.configure do |config|
  config.api_key = '15ac8a10c7b9e8939aa5608e186d3fd8'
  config.secure = false # only set this to true if you are on a paid Airbrake plan
end
Resque::Failure.backend = Resque::Failure::Airbrake
