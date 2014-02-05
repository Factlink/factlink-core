module Queries
  module Comments
    class ForFact
      include Pavlov::Query

      arguments :fact_data_id

      private

      def execute
        dead_comments_with_opinion
      end

      def comments
        Comment.where({fact_data_id: fact_data_id}).to_a
      end

      def dead_comments_with_opinion
        comments.map do |comment|
          query(:'comments/add_votes_and_deletable', comment: comment)
        end
      end
    end
  end
end
