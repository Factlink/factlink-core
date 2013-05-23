module Queries
  module Facts
    class GetDeadWheel
      include Pavlov::Query

      arguments :id

      def execute
        DeadFactWheel.new percentages[:authority],
          percentages[:believe][:percentage],
          percentages[:disbelieve][:percentage],
          percentages[:doubt][:percentage],
          user_opinion
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

      def user_opinion
        @options[:current_user].graph_user
          .opinion_on(fact)
      end

      def validate
        validate_integer_string :id, id
      end
    end
  end
end
