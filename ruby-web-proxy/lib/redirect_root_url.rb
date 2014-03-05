class RedirectRootUrl
  include Goliath::Rack::AsyncMiddleware
  def call(env)
    req = Rack::Request.new(env)
    if req.params["url"].nil?
      return redirect_to_factlink
    else
      super(env)
    end
  end

  def redirect_to_factlink
    location = 'https://factlink.com/'
    [
      301,
      {'Location' => location},
      %Q(Redirecting to <a href="#{location}">#{location}</a>)
    ]
  end
end
