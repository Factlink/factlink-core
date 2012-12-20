require_relative '../pavlov'

module Commands
  class DeleteComment
    include Pavlov::Command

    arguments :comment_id, :user_id

    def execute
      Comment.find(@comment_id).delete
    end

    def validate
      validate_hexadecimal_string :comment_id, @comment_id
      validate_hexadecimal_string :user_id, @user_id
    end

    def authorized?
      query :'comments/can_destroy', @comment_id, @user_id
    end
  end
end
