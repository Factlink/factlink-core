require 'goliath'

require 'em-synchrony'
require 'em-synchrony/em-http'

class Server < Goliath::API
  def response(env)
    req = Rack::Request.new(env)
    page = EM::HttpRequest.new(req.params["url"]).get
    resp = page.response

    [200, {}, resp]
  end
end
