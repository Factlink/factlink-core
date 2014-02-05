module Queries
  module Comments
    class AddVotesAndDeletable
      include Pavlov::Query

      arguments :comment

      def execute
        DeadComment.new(
          id: comment.id,
          created_by: query(:users_by_ids, user_ids: comment.created_by_id).first,
          created_at: comment.created_at,
          content: comment.content,
          type: comment.type,
          created_by_id: comment.created_by_id,
          sub_comments_count: Backend::SubComments.count(parent_id: comment.id),
          votes: votes,
          deletable?: deletable?,
        )
      end

      def votes
        believable.votes.merge current_user_opinion: current_user_opinion
      end

      def current_user_opinion
        current_user = pavlov_options[:current_user]
        return :no_vote unless current_user

        believable.opinion_of_graph_user current_user.graph_user
      end

      def believable
        @believable ||= ::Believable::Commentje.new comment.id
      end

      def deletable?
        EvidenceDeletable.new(comment, 'Comment', believable, graph_user_id_of_creator).deletable?
      end

      def graph_user_id_of_creator
        comment.created_by.graph_user_id
      end
    end
  end
end
