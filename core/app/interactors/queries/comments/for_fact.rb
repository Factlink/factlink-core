module Queries
  module Comments
    class ForFact
      include Pavlov::Query

      arguments :fact

      private

      def execute
        dead_comments_with_opinion
      end

      def comments
        Comment.where({fact_data_id: fact.data_id}).to_a
      end

      def dead_comments_with_opinion
        comments.map do |comment|
          comment.sub_comments_count = Backend::SubComments.count(parent_id: comment.id)
          dead_comment = query(:'comments/add_votes_and_deletable', comment: comment)

          dead_comment
        end
      end
    end
  end
end
