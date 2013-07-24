require 'pavlov'

module Queries
  module Opinions
    class UserOpinionForComment
      include Pavlov::Query

      arguments :comment_id, :fact

      def validate
        validate_hexadecimal_string :comment_id, comment_id
      end

      def execute
        dead_opinion
      end

      def dead_opinion
        DeadOpinion.from_opinion calculator.opinion
      end

      def calculator
        UserOpinionCalculation.new believable, &authority_for
      end

      def authority_for
        Proc.new do |graph_user|
          Authority.on(fact, for: graph_user).to_f + 1
        end
      end

      def believable
        Believable::Commentje.new(comment_id)
      end

    end
  end
end
