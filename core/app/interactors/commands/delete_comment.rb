require_relative '../pavlov'

module Commands
  class DeleteComment
    class NotPossibleError < StandardError
    end

    include Pavlov::Command

    arguments :comment_id, :user_id

    def execute
      raise_unauthorized unless comment.created_by_id.to_s == @user_id
      raise NotPossibleError unless comment.deletable?

      comment.delete
    end

    def comment
      @comment ||= Comment.find(@comment_id)
    end

    def validate
      validate_hexadecimal_string :comment_id, @comment_id
      validate_hexadecimal_string :user_id, @user_id
    end
  end
end
