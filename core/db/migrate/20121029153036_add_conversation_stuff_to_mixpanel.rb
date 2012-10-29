class AddConversationStuffToMixpanel < Mongoid::Migration
  def self.up
    @mixpanel = FactlinkUI::Application.config.mixpanel.new({}, true)

    Message.each do |m|
      @mixpanel.increment_person_event m.sender.id.to_s, messages_created: 1
    end
  end

  def self.down
  end
end
