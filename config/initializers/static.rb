static_conf_complete = ActiveSupport::HashWithIndifferentAccess.new({
  development: {
    hostname: "localhost",
    port: 8000,
    protocol: "http://"
  },
  test: {
    hostname: "localhost",
    port: 8000,
    protocol: "http://"
  },
  staging: {
    hostname: "factlink-static-staging.inverselink.com",
    port: 443,
    protocol: "https://"
  },
  production: {
    hostname: "static.factlink.com",
    port: 443,
    protocol: "https://"
  }
})
static_conf = static_conf_complete[Rails.env]


FactlinkUI::Application.config.static_url =
    static_conf[:protocol] + static_conf[:hostname] + ':' + static_conf[:port].to_s

FactlinkUI::Application.config.jslib_url =
  FactlinkUI::Application.config.static_url + '/lib/dist/factlink_loader' +
    if 'development' == Rails.env
      '.js'
    elsif 'test' == Rails.env
       '.invalid.js';
    else
      '.min.js';
    end
