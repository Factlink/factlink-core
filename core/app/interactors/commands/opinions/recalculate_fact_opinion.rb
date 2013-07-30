require 'pavlov'

module Commands
  module Opinions
    class RecalculateFactOpinion
      include Pavlov::Command

      arguments :fact
      attribute :pavlov_options, Hash, default: {}

      def execute
        Opinion::BaseFactCalculation.new(fact).calculate_user_opinion
        Opinion::FactCalculation.new(fact).calculate_opinion
      end

      def validate
        validate_not_nil :fact, fact
      end
    end
  end
end
