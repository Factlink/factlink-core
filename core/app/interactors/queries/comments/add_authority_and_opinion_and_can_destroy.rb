require 'pavlov'

module Queries
  module Comments
    class AddAuthorityAndOpinionAndCanDestroy
      include Pavlov::Query

      arguments :comment, :fact

      def execute
        KillObject.comment comment,
          opinion: opinion,
          current_user_opinion: current_user_opinion,
          authority: authority,
          can_destroy?: can_destroy,
          sub_comments_count: comment.sub_comments_count
      end

      def authority
        query :authority_on_fact_for, fact, comment.created_by.graph_user
      end

      def opinion
        query :'opinions/user_opinion_for_comment', comment.id.to_s, fact
      end

      def current_user_opinion
        return unless current_graph_user

        query :'comments/graph_user_opinion',
              comment.id.to_s, current_graph_user
      end

      def current_graph_user
        @options[:current_user].andand.graph_user
      end

      def can_destroy
        return false unless @options[:current_user]

        query :'comments/can_destroy', comment.id.to_s, @options[:current_user].id.to_s
      end
    end
  end
end
