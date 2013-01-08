require 'pavlov'
require_relative '../util/mixpanel'

module Interactors
  class ReplyToConversation
    include Pavlov::Interactor
    include Util::Mixpanel

    arguments :conversation_id, :sender_id, :content

    def execute
      conversation = Conversation.find(@conversation_id)
      message = command :create_message, @sender_id, @content, conversation

      sender = User.find(@sender_id)
      command :create_activity, sender.graph_user, :replied_message, message, nil

      track_mixpanel

      message
    end

    def track_mixpanel
      increment_person_event :replies_created
      track_event :reply_created
    end

    def authorized?
      #relay authorization to commands, only require a user to check
      @options[:current_user].id.to_s == @sender_id.to_s
    end
  end
end
