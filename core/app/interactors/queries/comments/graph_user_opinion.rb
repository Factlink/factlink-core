module Queries
  module Comments
    class GraphUserOpinion
      include Pavlov::Query
      arguments :comment_id, :graph_user

      def execute
        believable.opinion_of_graph_user graph_user
      end

      def believable
        @believable ||= ::Believable::Commentje.new comment_id
      end
    end
  end
end
