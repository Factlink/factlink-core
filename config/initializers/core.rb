core_conf_complete = ActiveSupport::HashWithIndifferentAccess.new({
  development: {
    hostname: 'localhost',
    port: 3000,
    protocol: 'http://',
  },
  test: {
    # Match urls used by Rails/Capybara
    hostname: '127.0.0.1',
    port: 3005,
    protocol: 'http://',
  },
  staging: {
    hostname: 'factlink-staging.inverselink.com',
    port: 443,
    protocol: 'https://',
  },
  production: {
    hostname: 'factlink.com',
    port: 443,
    protocol: 'https://',
  }
})

core_conf = core_conf_complete[Rails.env]

FactlinkUI::Application.config.core_url =
  URI.parse(core_conf[:protocol] + core_conf[:hostname] + ':' + core_conf[:port].to_s).to_s
FactlinkUI::Application.config.hostname =
  core_conf[:hostname]
