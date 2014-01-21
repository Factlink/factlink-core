module Queries
  module Comments
    class Get
      include Pavlov::Query
      arguments :comment_id

      def execute
        comment = Comment.find(@comment_id)

        # TODO: This should be in this query, this query doesn't have
        # a validate and is therefor not reusable.
        comment.sub_comments_count = Backend::SubComments.count(parent_id: comment.id)

        query(:'comments/add_votes_and_deletable', comment: comment)
      end
    end
  end
end
