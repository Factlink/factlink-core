# LOADED EAGERLY!
# for some reason has to be loaded before environment config,
# so the settings of action_mailer are made on time.
core_conf_complete = ActiveSupport::HashWithIndifferentAccess.new({
  development: 'http://127.0.0.1:3000/',
  test: 'http://127.0.0.1:3005/',
  staging: 'https://factlink-staging.inverselink.com:443/',
  production: 'https://factlink.com:443/',
})

core_url = ENV.fetch('FACTLINK_HOSTNAME', core_conf_complete[Rails.env])
url, protocol, hostname, port = core_url.match(%r{^(https?)://([^:/]*)(?::([0-9]+))/$}).to_a
unless url
  fail('invalid core url string')
end

FactlinkUI::Application.config.core_url =
  URI.parse(protocol + '://' + hostname + ':' + port).to_s
FactlinkUI::Application.config.hostname = hostname

FactlinkUI::Application.configure do
  config.action_mailer.default_url_options = {
    host: hostname,
    protocol: protocol,
    port: port,
  }
end
