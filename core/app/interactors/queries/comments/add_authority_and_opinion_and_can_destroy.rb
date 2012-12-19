require_relative '../../pavlov'

module Queries
  module Comments
    class AddAuthorityAndOpinionAndCanDestroy
      include Pavlov::Query
      arguments :comment, :fact
      def execute
        KillObject.comment @comment,
          opinion: opinion,
          current_user_opinion: current_user_opinion,
          authority: authority,
          can_destroy?: can_destroy
      end

      def authority
        query :authority_on_fact_for, @fact, @comment.created_by.graph_user
      end

      def opinion
        query :opinion_for_comment, @comment.id.to_s, @fact
      end

      def current_user_opinion
        query :'comments/graph_user_opinion',
              @comment.id.to_s, current_graph_user
      end

      def current_graph_user
        @options[:current_user].graph_user
      end

      def can_destroy
        created_by_current_user && @comment.deletable?
      end

      def created_by_current_user
        @comment.created_by_id == @options[:current_user].id
      end
    end
  end
end
