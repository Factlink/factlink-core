require 'raven'
class RavenCatcher
  include Goliath::Rack::AsyncMiddleware

  def initialize_raven(env)
    return if @raven_initialized
    Raven.configure do |config|
     config.dsn = env.config[:raven_dsn]
    end
    @raven_initialized = true
  end

  def capture_exception(exception, env, options = {})
    initialize_raven(env)
    Raven.capture_exception(exception, options) do |evt|
      evt.interface :http do |int|
        int.from_rack(env)
      end
    end
  end

  def post_process(env, status, headers, body)
    error = env['rack.exception'] || env['sinatra.error']
    capture_exception(error, env) if error && env.config[:raven_dsn]

    [status, headers, body]
  end
end
