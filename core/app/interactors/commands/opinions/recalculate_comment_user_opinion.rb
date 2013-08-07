module Commands
  module Opinions
    class RecalculateCommentUserOpinion
      include Pavlov::Command

      arguments :comment

      def execute
        FactGraph.new.calculate_comment_when_user_opinion_changed comment
      end

      def validate
        validate_not_nil :comment, comment
      end
    end
  end
end
