require 'pavlov'

module Queries
  module Comments
    class AddAuthorityAndOpinionAndCanDestroy
      include Pavlov::Query

      arguments :comment, :fact

      def execute
        KillObject.comment comment,
          impact_opinion: impact_opinion,
          current_user_opinion: current_user_opinion,
          authority: authority,
          can_destroy?: can_destroy,
          sub_comments_count: comment.sub_comments_count
      end

      def authority
        old_query :authority_on_fact_for, fact, comment.created_by.graph_user
      end

<<<<<<< HEAD
      def impact_opinion
        query :'opinions/impact_opinion_for_comment', comment
=======
      def opinion
        old_query :'opinions/user_opinion_for_comment', comment.id.to_s, fact
>>>>>>> develop
      end

      def current_user_opinion
        return unless current_graph_user

        old_query :'comments/graph_user_opinion',
              comment.id.to_s, current_graph_user
      end

      def current_graph_user
        pavlov_options[:current_user].andand.graph_user
      end

      def can_destroy
        return false unless pavlov_options[:current_user]

        old_query :'comments/can_destroy', comment.id.to_s, pavlov_options[:current_user].id.to_s
      end
    end
  end
end
