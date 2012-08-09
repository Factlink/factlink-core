extensions_conf = YAML::load_file(Rails.root.join('config/browser_extensions.yml'))[Rails.env]

FactlinkUI::Application.config.chrome_extension_ids =
  extensions_conf['chrome']['ids'] or []