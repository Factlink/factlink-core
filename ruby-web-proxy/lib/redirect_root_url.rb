class RedirectRootUrl
  include Goliath::Rack::AsyncMiddleware
  def call(env)
    req = Rack::Request.new(env)
    if req.params['url'].nil?
      location = env.config[:redirect_for_no_url]
      [
        301,
        { 'Location' => location },
        %Q(Redirecting to <a href="#{location}">#{location}</a>)
      ]
    else
      super(env)
    end
  end
end
