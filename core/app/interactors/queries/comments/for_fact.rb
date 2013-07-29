require 'pavlov'

module Queries
  module Comments
    class ForFact
      include Pavlov::Query

      arguments :fact, :type

      private

      def execute
        dead_comments_with_opinion
      end

      def comments
        type = OpinionType.for_relation_type(@type).to_s
        fact_data_id = fact.data_id
        Comment.where({fact_data_id: fact_data_id, type: type}).to_a
      end

      def dead_comments_with_opinion
        comments.map do |comment|
          comment.sub_comments_count = query :'sub_comments/count', comment.id.to_s, comment.class.to_s
          dead_comment = query :'comments/add_authority_and_opinion_and_can_destroy', comment, fact
          # TODO: don't depend on the fact that comment is an openstruct
          dead_comment.evidence_class = 'Comment'

          dead_comment
        end
      end
    end
  end
end
