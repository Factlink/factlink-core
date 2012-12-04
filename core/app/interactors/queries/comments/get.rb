module Queries
  module Comments
    class Get
      include Pavlov::Query
      arguments :comment_id

      def validate
        validate_hexadecimal_string :comment_id, @comment_id
      end

      def execute
        comment = Comment.find(@comment_id)
        fact = comment.fact_data.fact
        query :'comments/add_authority_and_opinion', comment, fact
      end
    end
  end
end
