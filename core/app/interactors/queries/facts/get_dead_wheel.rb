module Queries
  module Facts
    class GetDeadWheel
      include Pavlov::Query

      arguments :id

      def execute
        DeadFactWheel.new percentages[:authority],
          percentages[:believe][:percentage],
          percentages[:disbelieve][:percentage],
          percentages[:doubt][:percentage]
      end

      def percentages
        opinion.as_percentages
      end

      def opinion
        fact.get_opinion
      end

      def fact
        Fact[id]
      end

      def validate
        validate_integer_string :id, id
      end
    end
  end
end
