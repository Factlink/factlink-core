require_relative '../pavlov'

module Commands
  class CreateComment
    include Pavlov::Command

    arguments :fact_data_id, :opinion, :content, :user_id

    def execute
      comment = Comment.new
      comment.fact_data = fact_data
      comment.created_by = creator
      comment.opinion = @opinion
      comment.content = @content
      comment.save
    end

    def fact_data
      FactData.find(@fact_data_id)
    end

    def creator
      User.find(@user_id)
    end

    def validate
      validate_integer :user_id, @user_id
      validate_regex   :content, @content, /\A.+\Z/,
        "should not be empty."
      validate_hexadecimal_string :fact_data_id, @fact_data_id
      validate_in_set  :opinion, @opinion, ['believes', 'disbelieves', 'doubts']
    end
  end
end
