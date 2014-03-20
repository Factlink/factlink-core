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

  def capture_exception(env, options = {})
    exception = env['rack.exception']
    initialize_raven(env)
    Raven.capture_exception(exception, options) do |evt|
      evt.interface :http do |int|
        int.from_rack(env)
      end
    end
  end

  def post_process(env, status, headers, body)
    if env.config[:raven_dsn] && env['rack.exception']
      capture_exception(env)
    end

    [status, headers, body]
  end
end
