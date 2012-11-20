require_relative '../pavlov'

module Commands
  class DeleteComment
    include Pavlov::Command

    arguments :comment_id, :user_id

    def execute
      comment = Comment.find(@comment_id)
      user = User.find(@user_id)
      raise Pavlov::AccessDenied.new 'Unauthorized' unless comment.created_by == user
      comment.delete
    end

    def authorized?
      true
    end

    def validate
      validate_hexadecimal_string :comment_id, @comment_id
      validate_integer :user_id, @user_id
    end
  end
end
