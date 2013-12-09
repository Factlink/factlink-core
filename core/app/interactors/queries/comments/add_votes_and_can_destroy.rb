module Queries
  module Comments
    class AddVotesAndCanDestroy
      include Pavlov::Query

      arguments :comment

      def execute
        KillObject.comment comment,
          votes: votes,
          can_destroy?: can_destroy,
          sub_comments_count: comment.sub_comments_count
      end

      def votes
        query(:'believable/votes', believable: believable)
      end

      def believable
        @believable ||= ::Believable::Commentje.new comment.id
      end

      def can_destroy
        return false unless pavlov_options[:current_user]

        query(:'comments/can_destroy',
                  comment_id: comment.id.to_s,
                  user_id: pavlov_options[:current_user].id.to_s)
      end
    end
  end
end
