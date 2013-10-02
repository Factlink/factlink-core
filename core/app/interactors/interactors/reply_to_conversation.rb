require_relative '../util/mixpanel'

module Interactors
  class ReplyToConversation
    include Pavlov::Interactor
    include Util::Mixpanel

    arguments :conversation_id, :sender_id, :content

    def execute
      conversation = Conversation.find(conversation_id)
      message = command(:'create_message',
                            sender_id: sender_id, content: content,
                            conversation: conversation)

      sender = User.find(sender_id)
      command(:'create_activity',
                  graph_user: sender.graph_user, action: :replied_message,
                  subject: message, object: nil)

      track_mixpanel

      message
    end

    def track_mixpanel
      mp_increment_person_property :replies_created
      mp_track "Conversation: Replied to conversation",
        conversation_id: conversation_id
    end

    def validate
      unless content.strip.length > 0
        errors.add :content, 'cannot be empty'
      end
      unless content.length <= 5000
        errors.add :content, 'cannot be longer than 5000 characters.'
      end
      validate_hexadecimal_string :conversation_id, conversation_id
    end

    def authorized?
      #relay authorization to commands, only require a user to check
      pavlov_options[:current_user].id.to_s == sender_id.to_s
    end
  end
end
