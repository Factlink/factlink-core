class RepliedConversationObject < Mongoid::Migration
  def self.up
    activities = Activity.find(action: :replied_conversation)
    activities.each do |activity|
      message = activity.subject.andand.messages.andand.last
      if message == nil
        activity.delete
      else
        activity.subject = message
        activity.action = :replied_message
        activity.save
      end
    end
  end

  def self.down
  end
end
