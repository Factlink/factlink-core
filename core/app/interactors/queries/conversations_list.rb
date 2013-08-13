module Queries
  class ConversationsList
    include Pavlov::Query

    arguments :user_id

    def execute
      User.find(@user_id).conversations.desc(:updated_at).map do |conversation|
        # TODO: eliminate implicit query in next line (retrieving fact_data)
        fact_data = conversation.fact_data
        fact_id = fact_data && fact_data.fact_id
        KillObject.conversation(conversation, fact_id: fact_id)
      end
    end
  end
end
