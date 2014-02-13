module Queries
  module Comments
    class ByIds
      include Pavlov::Query

      attribute :ids
      attribute :by, Symbol, default: :_id
      attribute :pavlov_options

      def validate
        validate_in_set :by, by, [:_id, :fact_data_id]
      end

      def execute
        comments.map do |comment|
          dead_for(comment)
        end
      end

      def comments
        Comment.all_in(by => Array(ids))
      end

      def dead_for comment
        believable = ::Believable::Commentje.new comment.id

        DeadComment.new(
          id: comment.id,
          created_by: query(:dead_users_by_ids, user_ids: comment.created_by_id).first,
          created_at: comment.created_at.utc.iso8601,
          formatted_content: FormattedCommentContent.new(comment.content).html,
          sub_comments_count: Backend::SubComments.count(parent_id: comment.id),
          is_deletable: deletable?(comment, believable),
          tally: votes(believable).slice(:believes, :disbelieves, :current_user_opinion)
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
