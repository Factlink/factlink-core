module Queries
  module Comments
    class AddAuthorityAndOpinion
      include Pavlov::Query
      arguments :comment, :fact
      def execute
        @comment.authority = query :authority_on_fact_for, @fact, @comment.created_by.graph_user
        opinion_object = query :opinion_for_comment, @comment.id.to_s, @fact

        KillObject.comment @comment, opinion_object: opinion_object
      end
    end
  end
end
