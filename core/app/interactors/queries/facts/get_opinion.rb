module Queries
  module Facts
    class GetOpinion
      include Pavlov::Query

      arguments :fact

      private

      def execute
        fact.get_opinion
      end
    end
  end
end
