require_relative '../../pavlov'

module Interactors
  module Comments
    class SetOpinion
      include Pavlov::Interactor

      arguments :comment_id, :opinion

      def execute
        command 'comment/set_opinion', @comment_id, @opinion

        comment.authority = authority_of comment
        comment
      end

      def validate
        validate_hexadecimal_string :comment_id, @comment_id
        validate_in_set :opinion, @opinion, ['believes', 'disbelieves', 'doubts']
      end

      def comment
        @comment ||= Comment.find(@comment_id)
      end

      def authority_of comment
        fact = comment.fact_data.fact
        graph_user = comment.created_by.graph_user
        query :authority_on_fact_for, fact, graph_user
      end

      def authorized?
        @options[:current_user]
      end
    end
  end
end
