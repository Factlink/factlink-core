require 'raven'

Raven.configure do |config|
  config.dsn = 'https://d118afe1c59843768beadf6b27ea52aa:7920d14f273b4fb493ef717634a5d024@sentry2.factlink.com/11'
end

class RavenCatcher
  include Goliath::Rack::AsyncMiddleware

  def capture_exception(exception, env, options = {})
    puts 'hoi'
    Raven.capture_exception(exception, options) do |evt|
      evt.interface :http do |int|
        int.from_rack(env)
      end
    end
  end

  def initialize(app)
    @app = app
  end

  def post_process(env, status, headers, body)
    error = env['rack.exception'] || env['sinatra.error']
    capture_exception(error, env) if error

    [status, headers, body]
  end
end
