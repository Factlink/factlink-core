class MixpanelTrackEventJob
  @queue = :slow

  def self.perform(event, params, req_env, user_id, username)
    @mixpanel = FactlinkUI::Application.config.mixpanel.new(req_env, true)

    @mixpanel.append_api(:identify, user_id)  if user_id
    @mixpanel.append_api(:name_tag, username) if username

    @mixpanel.track_event(event, params)
  end
end