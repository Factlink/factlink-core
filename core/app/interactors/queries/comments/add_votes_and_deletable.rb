module Queries
  module Comments
    class AddVotesAndDeletable
      include Pavlov::Query

      arguments :comment

      def execute
        KillObject.comment comment,
          votes: votes,
          deletable?: deletable,
          sub_comments_count: comment.sub_comments_count
      end

      def votes
        query(:'believable/votes', believable: believable)
      end

      def believable
        @believable ||= ::Believable::Commentje.new comment.id
      end

      def deletable
        query(:'comments/deletable', comment_id: comment.id.to_s)
      end
    end
  end
end
