class ConversationObserver < Mongoid::Observer

  def after_create conversation
    mixpanel = FactlinkUI::Application.config.mixpanel.new({}, true)

    mixpanel.track_event :conversation_created
  end

end
