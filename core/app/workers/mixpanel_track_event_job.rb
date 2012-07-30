class MixpanelTrackEventJob
  @queue = :slow

  def self.perform(event, params, req_env, user_id, username)
    @@mixpanel.track_event(event, params)
  end
end
