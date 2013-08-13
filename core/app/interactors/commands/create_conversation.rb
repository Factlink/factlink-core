module Commands
  class CreateConversation
    include Pavlov::Command

    arguments :fact_id, :recipient_usernames

    def validate
      raise 'recipient_usernames should be a list'    unless recipient_usernames.respond_to? :each
      raise 'recipient_usernames should not be empty' unless recipient_usernames.length > 0
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
