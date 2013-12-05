module Queries
  module Comments
    class AddOpinionAndCanDestroy
      include Pavlov::Query

      arguments :comment

      def execute
        KillObject.comment comment,
          impact_opinion: impact_opinion,
          current_user_opinion: current_user_opinion,
          can_destroy?: can_destroy,
          sub_comments_count: comment.sub_comments_count
      end

      def impact_opinion
        query(:'opinions/impact_opinion_for_comment', comment: comment)
      end

      def current_user_opinion
        return unless current_graph_user

        query(:'comments/graph_user_opinion',
                  comment_id: comment.id.to_s, graph_user: current_graph_user)
      end

      def current_graph_user
        if pavlov_options[:current_user]
          pavlov_options[:current_user].graph_user
        else
          nil
        end
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
