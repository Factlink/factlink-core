require 'goliath'
require 'json'
require 'em-synchrony'
require 'em-synchrony/em-http'

require_relative './lib/web_proxy'
require_relative './lib/add_factlink_to_page'
require_relative './lib/redirect_root_url'
require_relative './lib/redirect_if_publisher'



class Server < WebProxy
  use RedirectRootUrl
  use RedirectIfPublisher
  use AddFactlinkToPage
end

