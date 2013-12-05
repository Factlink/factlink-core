module Queries
  module Facts
    class GetVotes
      include Pavlov::Query

      arguments :id

      def execute
        votes.merge current_user_opinion: current_user_opinion
      end

      def votes
        fact.believable.votes
      end

      def fact
        @fact ||= Fact[id]
      end

      def current_user_opinion
        return :no_vote unless current_user

        fact.believable.opinion_of_graph_user current_user.graph_user
      end

      def current_user
        pavlov_options[:current_user]
      end
    end
  end
end
