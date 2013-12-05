module Queries
  module Comments
    class Get
      include Pavlov::Query
      arguments :comment_id

      def validate
        validate_hexadecimal_string :comment_id, @comment_id
      end

      def execute
        comment = Comment.find(@comment_id)

        # TODO: This should be in this query, this query doesn't have
        # a validate and is therefor not reusable.
        comment.sub_comments_count = query(:'sub_comments/count',
                                              parent_id: comment.id.to_s,
                                              parent_class: comment.class.to_s)

        query(:'comments/add_votes_and_can_destroy',
                  comment: comment)

      end
    end
  end
end
