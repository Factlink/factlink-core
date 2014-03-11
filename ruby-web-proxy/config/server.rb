environment :development do
  config[:redirect_for_no_url] = 'https://localhost:3000/'
  config[:hostname] = 'localhost'
  config[:host] = 'http://localhost:4567'
  config[:jslib_uri] = 'http://localhost:8000/lib/dist/factlink_loader.js?o=proxy'
  config[:raven_dsn] = 'https://d118afe1c59843768beadf6b27ea52aa:7920d14f273b4fb493ef717634a5d024@sentry2.factlink.com/11'
end

environment :production do
  config[:redirect_for_no_url] = 'https://factlink.com/'
  config[:hostname] = 'localhost'
  config[:host] = 'http://localhost:4567'
  config[:jslib_uri] = 'http://localhost:8000/lib/dist/factlink_loader.js?o=proxy'
  config[:raven_dsn] = 'https://d118afe1c59843768beadf6b27ea52aa:7920d14f273b4fb493ef717634a5d024@sentry2.factlink.com/11'
end

config[:http_requester] = ->(url) { EM::HttpRequest.new(url).get }

