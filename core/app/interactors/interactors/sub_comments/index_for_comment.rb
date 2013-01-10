require 'pavlov'

module Interactors
  module SubComments
    class IndexForComment
      include Pavlov::Interactor

      arguments :comment_id

      def validate
        validate_hexadecimal_string :comment_id, @comment_id
      end

      def authorized?
        @options[:current_user]
      end

      def execute
        throw "comment does not exist anymore" unless comment
        
        result = query :'sub_comments/index', @comment_id, 'Comment'

        result.map do |sub_comment|
          KillObject.sub_comment sub_comment,
            authority: authority_of_user_who_created(sub_comment)
        end
      end

      def top_fact
        @top_fact ||= comment.fact_data.fact
      end

      def comment
        @comment ||= Comment.find(@comment_id)
      end

      def authority_of_user_who_created sub_comment
        query :authority_on_fact_for, top_fact, sub_comment.created_by.graph_user
      end
    end
  end
end
