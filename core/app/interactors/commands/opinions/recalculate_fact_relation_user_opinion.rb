require 'pavlov'

module Commands
  module Opinions
    class RecalculateFactRelationUserOpinion
      include Pavlov::Command

      arguments :fact_relation

      def execute
        Opinion::BaseFactCalculation.new(fact_relation).calculate_user_opinion
      end

      def validate
        validate_not_nil :fact_relation, fact_relation
      end
    end
  end
end
