class RedirectIfPublisher
  include Goliath::Rack::AsyncMiddleware

  def post_process(env, status, headers, body)
    if (200..299).cover?(status) &&
         body.match(/factlink_loader(_publishers)?\.min\.js/)
      location = headers.fetch('X-Proxied-Location')
      [
        301,
        { 'Location' => location },
        %Q(Redirecting to <a href="#{location}">#{location}</a>)
      ]
    else
      [status, headers, body]
    end
  end
end
