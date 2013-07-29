module Queries
  module Opinions
    class ImpactOpinionForComment
      include Pavlov::Query

      arguments :comment

      private

      def execute
        FactGraph.new.impact_opinion_for_comment(comment)
      end

      def validate
        validate_not_nil :comment, comment
      end
    end
  end
end
