module Queries
  module Opinions
    class ImpactOpinionForComment
      include Pavlov::Query

      arguments :comment

      private

      def execute
        evidence_type = OpinionType.real_for(alive_comment.type)

        DeadOpinion.for_type(evidence_type, alive_comment.believable.dead_opinion.net_authority)
      end

      def alive_comment
        @alive_comment ||= Comment.find(comment.id)
      end

      def validate
        validate_not_nil :comment, comment
      end
    end
  end
end
