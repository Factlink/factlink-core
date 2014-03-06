class RedirectIfPublisher
  include Goliath::Rack::AsyncMiddleware

  def post_process(env, status, headers, body)
    if env[:web_proxy_proxied] &&
         body.match(/factlink_loader(_publishers)?\.min\.js/)
      location = env[:web_proxy_proxied_location]

      env[:web_proxy_proxied] = false
      env[:web_proxy_proxied_location] = nil

      [
        301,
        {"Location" => location},
        %Q(Redirecting to <a href="#{location}">#{location}</a>)
      ]

    else
      [status, headers, body]
    end

  end
end
