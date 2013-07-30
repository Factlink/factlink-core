module Queries
  module Opinions
    class ImpactOpinionForComment
      include Pavlov::Query

      arguments :comment

      private

      def execute
        FactGraph.new.impact_opinion_for_comment(comment, allow_negative_authority: true)
      end

      def validate
        validate_not_nil :comment, comment
      end
    end
  end
end
