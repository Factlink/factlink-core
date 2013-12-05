module Mixpanel
  class TrackPeopleEventJob
    @queue = :mmm_mixpanel

    def self.perform(user_id, opts, req_env)
      mixpanel = FactlinkUI::Application.config.mixpanel.new(req_env, true)
      mixpanel.set_person_event user_id, opts
    end
  end
end
