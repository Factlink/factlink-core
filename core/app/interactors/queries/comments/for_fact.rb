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
          comment.sub_comments_count = query(:'sub_comments/count', parent_id: comment.id.to_s)
          dead_comment = query(:'comments/add_votes_and_deletable', comment: comment)

          # TODO: don't depend on the fact that comment is an openstruct
          dead_comment.evidence_class = 'Comment'

          dead_comment
        end
      end
    end
  end
end
