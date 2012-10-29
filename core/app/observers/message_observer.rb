class MessageObserver < Mongoid::Observer

  def after_create message
    mixpanel = FactlinkUI::Application.config.mixpanel.new({}, true)

    mixpanel.increment_person_event message.sender.id.to_s, messages_created: 1
    mixpanel.track_event :message_created
  end

end
