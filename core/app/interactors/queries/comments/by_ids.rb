module Queries
  module Comments
    class ByIds
      include Pavlov::Query

      attribute :ids
      attribute :by
      attribute :pavlov_options

      def execute
        comments.map do |comment|
          dead_for(comment)
        end
      end

      def comments
        Comment.all_in(by => ids)
      end

      def dead_for comment
        believable = ::Believable::Commentje.new comment.id

        DeadComment.new(
          id: comment.id,
          created_by: query(:users_by_ids, user_ids: comment.created_by_id).first,
          created_at: comment.created_at,
          content: comment.content,
          type: comment.type,
          created_by_id: comment.created_by_id,
          sub_comments_count: Backend::SubComments.count(parent_id: comment.id),
          votes: votes(believable),
          deletable?: deletable?(comment, believable),
        )
      end

      def votes(believable)
        believable.votes.merge current_user_opinion: current_user_opinion(believable)
      end

      def current_user_opinion(believable)
        current_user = pavlov_options[:current_user]
        return :no_vote unless current_user

        believable.opinion_of_graph_user current_user.graph_user
      end

      def deletable?(comment, believable)
        EvidenceDeletable.new(comment, 'Comment', believable, comment.created_by.graph_user_id).deletable?
      end
    end
  end
end
