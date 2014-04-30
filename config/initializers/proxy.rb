proxy_conf_complete = ActiveSupport::HashWithIndifferentAccess.new({
  development: {
    hostname: "localhost",
    port: 8080,
  },
  test: {
    hostname: "localhost",
    port: 8080,
  },
  staging: {
    hostname: "staging.fct.li",
    port: 80,
  },
  production: {
    hostname: "fct.li",
    port: 80,
  },
})

proxy_conf = proxy_conf_complete[Rails.env]
FactlinkUI::Application.config.proxy_url = 'http://' + proxy_conf['hostname'] + ':' + proxy_conf['port'].to_s
