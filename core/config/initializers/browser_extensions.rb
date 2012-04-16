extensions_conf = YAML::load_file(Rails.root.join('config/browser_extensions.yml'))[Rails.env]['chrome']
FactlinkUI::Application.config.chrome_extension_id = extensions_conf['id']
 