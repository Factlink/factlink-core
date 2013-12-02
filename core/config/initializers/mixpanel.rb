if ["production"].include?(Rails.env)
  mixpanel_conf = YAML::load_file(Rails.root.join('config/mixpanel.yml'))[Rails.env]['mixpanel']

  FactlinkUI::Application.config.mixpanel_token = mixpanel_conf['token']
  FactlinkUI::Application.config.mixpanel = MixpanelRails::Tracker

  FactlinkUI::Application.config.middleware.use "Mixpanel::Tracker::Middleware", mixpanel_conf['token'], insert_js_last: true
else


  FactlinkUI::Application.config.mixpanel = MixpanelRails::DummyTracker
end
