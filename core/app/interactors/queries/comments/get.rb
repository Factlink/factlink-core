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
        # TODO: This should be in this query, this query doesn't have
        # a validate and is therefor not reusable.
        query :'comments/add_authority_and_opinion_and_can_destroy', comment, fact
      end
    end
  end
end
