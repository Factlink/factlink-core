module Mixpanel
  class TrackEventJob
    @queue = :slow

    def self.perform(event, params, req_env)
      mixpanel = FactlinkUI::Application.config.mixpanel.new(req_env, true)
      mixpanel.track_event(event, params)
    end
  end
end
