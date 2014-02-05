module Queries
  module Comments
    class Get
      include Pavlov::Query
      arguments :comment_id

      def execute
        comment = Comment.find(@comment_id)

        query(:'comments/add_votes_and_deletable', comment: comment)
      end
    end
  end
end
