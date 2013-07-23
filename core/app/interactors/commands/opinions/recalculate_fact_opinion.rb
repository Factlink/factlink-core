require 'pavlov'

module Commands
  module Opinions
    class RecalculateFactOpinion
      include Pavlov::Command

      arguments :fact

      def execute
        Opinion::FactCalculation.new(fact).calculate_opinion(1)
      end

      def validate
        validate_not_nil :fact, fact
      end
    end
  end
end
