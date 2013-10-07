module Commands
  class CreateConversation
    include Pavlov::Command
    include Util::Validations

    arguments :fact_id, :recipient_usernames

    def validate
      validate_non_empty_list :recipient_usernames, recipient_usernames
    end

    def execute
      conversation = Conversation.new
      recipient_usernames.each do |username|
        user = query :user_by_username, username: username
        raise Pavlov::ValidationError, 'user_not_found' unless user
        conversation.recipients << user
      end

      fact = Fact[fact_id]
      conversation.fact_data_id = fact.data_id
      conversation.save
      conversation
    end
  end
end
