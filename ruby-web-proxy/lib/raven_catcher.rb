require 'raven'
class RavenCatcher
  include Goliath::Rack::AsyncMiddleware

  def capture_exception(exception, env, options = {})
    Raven.capture_exception(exception, options) do |evt|
      evt.interface :http do |int|
        int.from_rack(env)
      end
    end
  end

  def post_process(env, status, headers, body)
    error = env['rack.exception'] || env['sinatra.error']
    capture_exception(error, env) if error

    [status, headers, body]
  end
end
