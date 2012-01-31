if ["production"].include?(Rails.env)
  mixpanel_conf = YAML::load_file(Rails.root.join('config/mixpanel.yml'))[Rails.env]['mixpanel']

  FactlinkUI::Application.config.mixpanel_token = mixpanel_conf['token']

  FactlinkUI::Application.config.middleware.use "Mixpanel::Tracker::Middleware", mixpanel_conf['token']
else
  class DummyMixpanel
    def method_missing(m, *args, &block)
      true
    end
  end
end