require 'goliath'
require 'json'
require 'em-synchrony'
require 'em-synchrony/em-http'

require_relative './lib/web_proxy'
require_relative './lib/add_factlink_to_page'
require_relative './lib/redirect_root_url'
require_relative './lib/redirect_if_publisher'
require_relative './lib/strip_publisher_script'
require_relative './lib/raven_catcher'

class Server < WebProxy
  use RedirectRootUrl
  if Goliath.env == :production
    use RedirectIfPublisher
  else
    use StripPublisherScript
  end
  use AddFactlinkToPage
  use RavenCatcher
end
