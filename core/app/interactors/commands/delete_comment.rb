require_relative '../pavlov'

module Commands
  class DeleteComment
    include Pavlov::Command

    arguments :comment_id, :user_id

    def execute
      comment = Comment.find(@comment_id)
      user = User.find(@user_id)
      raise_unauthorized unless comment.created_by_id.to_s == @user_id
      comment.delete
    end

    def validate
      validate_hexadecimal_string :comment_id, @comment_id
      validate_hexadecimal_string :user_id, @user_id
    end
  end
end
