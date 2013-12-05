sirportly_conf = YAML::load_file(Rails.root.join('config/sirportly.yml'))[Rails.env]['sirportly']

FactlinkUI::Application.config.sirportly_webform_id = sirportly_conf['webform_id']
