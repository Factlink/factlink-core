require_relative '../pavlov'

module Commands
  class CreateComment
    include Pavlov::Command

    arguments :fact_id, :opinion, :content, :user_id

    def execute
      comment = Comment.new
      comment.fact_data = fact_data
      creator = get_creator
      comment.created_by = creator
      comment.opinion = @opinion
      comment.content = @content
      comment.save

      KillObject.comment comment
    end

    def fact_data
      fact = Fact[@fact_id]
      FactData.find(fact.data_id)
    end

    def get_creator
      User.find(@user_id)
    end

    def validate
      validate_hexadecimal_string :user_id, @user_id
      validate_regex              :content, @content, /\A.+\Z/,
        "should not be empty."
      validate_integer            :fact_id, @fact_id
      validate_in_set             :opinion, @opinion, ['believes', 'disbelieves', 'doubts']
    end
  end
end
