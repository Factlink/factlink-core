if ["production", "staging"].include?(Rails.env)
  mixpanel_conf = YAML::load_file(Rails.root.join('config/mixpanel.yml'))[Rails.env]['mixpanel']

  FactlinkUI::Application.config.mixpanel_token = mixpanel_conf['token']
  FactlinkUI::Application.config.mixpanel = MixpanelRails::Tracker
else
  FactlinkUI::Application.config.mixpanel_token = 'none'
  FactlinkUI::Application.config.mixpanel = MixpanelRails::DummyTracker
end
