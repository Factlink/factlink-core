module MixpanelRails
  class DummyTracker
    def initialize(*args)
    end

    def method_missing(m, *args, &block)
      true
    end
  end

  class Tracker < Mixpanel::Tracker
    def initialize(env, async = false, url = 'http://api.mixpanel.com/track/?data=')
      super(FactlinkUI::Application.config.mixpanel_token, env, async, url)
    end
  end
end