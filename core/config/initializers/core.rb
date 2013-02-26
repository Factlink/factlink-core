core_conf = YAML::load_file(Rails.root.join('config/core.yml'))[Rails.env]['core']
FactlinkUI::Application.config.api_url = core_conf['protocol'] + core_conf['hostname'] + ':' + core_conf['port'].to_s
FactlinkUI::Application.config.hostname = core_conf['hostname']
