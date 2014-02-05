module Commands
  class CreateComment
    include Pavlov::Command

    arguments :fact_id, :type, :content, :user_id

    def execute
      comment = Comment.new
      comment.fact_data = fact_data
      creator = get_creator
      comment.created_by = creator
      comment.type = type
      comment.content = content
      comment.save!

      comment
    end

    def fact_data
      fact = Fact[fact_id]
      FactData.find(fact.data_id)
    end

    def get_creator
      User.find(user_id)
    end
  end
end
