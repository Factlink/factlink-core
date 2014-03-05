require 'goliath'

require 'em-synchrony'
require 'em-synchrony/em-http'
require_relative './lib/web_proxy'
require_relative './lib/inject_factlink'
require_relative './lib/redirect_root_url'

class Server < WebProxy
  use InjectFactlink
  use RedirectRootUrl

  def add_to_head location
    super + "<!-- doei -->"
  end
end

