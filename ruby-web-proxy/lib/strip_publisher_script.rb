class StripPublisherScript
  include Goliath::Rack::AsyncMiddleware

  def post_process(env, status, headers, body)
    if env[:web_proxy_proxied]

      body.gsub!(/factlink_loader(_publishers)?\.min\.js/,
                 'factlink_loader.min.js.DEACTIVATED')
    end

    [status, headers, body]
  end
end
