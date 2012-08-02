static_conf = YAML::load_file(Rails.root.join('config/static.yml'))[Rails.env]['static']
FactlinkUI::Application.config.static_url =
    static_conf['protocol'] + static_conf['hostname'] +
       ':' + static_conf['port'].to_s

JsLibUrl.base_url = FactlinkUI::Application.config.static_url
JsLibUrl.salt     = 'TOP_SEKRIT'