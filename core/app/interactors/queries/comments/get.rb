module Queries
  module Comments
    class Get
      include Queries::Comments::CommonFunctionality
      arguments comment_id

      def validate
        validate_hexadecimal_string :comment_id, @comment_id
      end

      def execute
        comment = Comment.find(@comment_id)
        extended_comment comment, comment.fact_data.fact
      end
    end
  end
end
