class ClearCookies
  include Goliath::Rack::AsyncMiddleware

  def post_process(env, status, headers, body)
    proxy_hostname = env.config[:hostname]
    request = Rack::Request.new(env)
    response = Rack::Response.new(body, status, headers)
    request.cookies.each do |cookie|
      response.clearCookie(name)
      response.clearCookie(name, domain: proxy_hostname)
    end
    response.finish
  end
end
