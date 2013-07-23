require 'pavlov'

module Commands
  module Opinions
    class RecalculateFactOpinion
      include Pavlov::Command

      arguments :fact

      def execute
        Opinion::BaseFactCalculation.new(fact).calculate_user_opinion
        fact_calculation.calculate_evidence_opinion
        fact_calculation.calculate_opinion
      end

      def fact_calculation
        @fact_calculation ||= Opinion::FactCalculation.new(fact)
      end

      def validate
        validate_not_nil :fact, fact
      end
    end
  end
end
