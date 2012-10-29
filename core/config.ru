# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
require ::File.expand_path('../app/middleware/resque.rb',__FILE__)

map '/' do
  run FactlinkUI::Application
end

# resque_constraint = lambda do |request|
#   request.env['warden'].authenticate? and request.env['warden'].user.admin?
# end

map '/a/resque' do
  # We're doing this so that the same cookie is used across
  # Resque Web and the Rails App
  use Rack::Session::Cookie, :key => '_FactlinkUI_session',
    :secret => FactlinkUI::Application.config.secret_token

  # Typical warden setup but instead of having resque web handle
  # failure, we'll pass it off to the rails app so that devise
  # can take care of it.
  use Warden::Manager do |manager|
    manager.failure_app = FactlinkUI::Application
    manager.default_scope = Devise.default_scope
  end

  run FactlinkUI::Resque
end
