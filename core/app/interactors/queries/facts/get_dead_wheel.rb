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
        @percentages ||= OpinionPresenter.new(opinion).as_percentages_hash
      end

      def opinion
        query(:'opinions/opinion_for_fact', fact: fact)
      end

      def fact
        @fact ||= Fact[id]
      end

      def user_opinion
        return nil unless current_user

        fact.believable.opinion_of_graph_user current_user.graph_user
      end

      def current_user
        pavlov_options[:current_user]
      end

      def validate
        validate_integer_string :id, id
      end
    end
  end
end
