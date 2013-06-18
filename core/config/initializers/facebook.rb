app_namespace = YAML::load_file(Rails.root.join('config/facebook.yml'))[Rails.env].andand['facebook_app_namespace']

if app_namespace
  FactlinkUI::Application.config.facebook_app_namespace = app_namespace
end
