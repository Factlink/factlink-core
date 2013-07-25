require 'pavlov'

module Commands
  module Opinions
    class RecalculateFactOpinion
      include Pavlov::Command

      arguments :fact

      def execute
        FactGraph.new.calculate_fact_when_user_authority_changed(fact)
      end

      def validate
        validate_not_nil :fact, fact
      end
    end
  end
end
