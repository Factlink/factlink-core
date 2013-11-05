extensions_conf = YAML::load_file(Rails.root.join('config/browser_extensions.yml')).fetch(Rails.env,{})

FactlinkUI::Application.config.chrome_extension_id = extensions_conf.fetch('chrome',{})['id']
FactlinkUI::Application.config.use_chrome_webstore = Rails.env == "production"
