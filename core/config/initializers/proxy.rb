proxy_conf = YAML::load_file(Rails.root.join('config/proxy.yml'))[Rails.env]

FactlinkUI::Application.config.proxy_url = "http://" + proxy_conf['host'] + ':' + proxy_conf['port']
