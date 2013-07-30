require 'pavlov'
require_relative '../util/mixpanel'

module Interactors
  class ReplyToConversation
    include Pavlov::Interactor
    include Util::Mixpanel

    arguments :conversation_id, :sender_id, :content

    def execute
      conversation = Conversation.find(@conversation_id)
      message = old_command :create_message, sender_id, content, conversation

      sender = User.find(@sender_id)
      old_command :create_activity, sender.graph_user, :replied_message, message, nil

      track_mixpanel

      message
    end

    def track_mixpanel
      mp_increment_person_property :replies_created
      mp_track "Conversation: Replied to conversation",
        conversation_id: @conversation_id
    end

    def authorized?
      #relay authorization to commands, only require a user to check
      pavlov_options[:current_user].id.to_s == @sender_id.to_s
    end
  end
end
