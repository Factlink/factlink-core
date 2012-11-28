require_relative '../pavlov'

module Queries
  class AuthorityOfCreatedUserForComment
    include Pavlov::Query

    arguments :comment_id

    def validate
      validate_hexadecimal_string :comment_id, @comment_id
    end

    def execute
      comment = Comment.find(@comment_id)

      # NOTE: This shortcut of using `comment.fact_data.fact` instead of `comment` itself
      # is possible because in the current calculation these authorities are the same
      authority = Authority.on(comment.fact_data.fact, for: comment.created_by.graph_user)
      authority.to_s(1.0)
    end
  end
end
