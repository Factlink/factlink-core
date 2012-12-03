require_relative '../../pavlov'
require_relative '../../queries/comments/common_functionality.rb'

module Interactors
  module Comments
    class SetOpinion
      include Pavlov::Interactor
      include Queries::Comments::CommonFunctionality

      arguments :comment_id, :opinion

      def execute
        command 'comments/set_opinion', @comment_id, @opinion, @options[:current_user].graph_user
        comment
      end

      def comment
        # TODO-0312 extract to query
        comment = Comment.find(@comment_id)
        extended_comment comment, comment.fact_data.fact
      end

      def validate
        validate_hexadecimal_string :comment_id, @comment_id
        validate_in_set :opinion, @opinion, ['believes', 'disbelieves', 'doubts']
      end

      def authorized?
        @options[:current_user]
      end
    end
  end
end
