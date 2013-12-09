module Queries
  module Believable
    class Votes
      include Pavlov::Query

      arguments :believable

      def execute
        votes.merge current_user_opinion: current_user_opinion
      end

      def votes
        believable.votes
      end

      def current_user_opinion
        return :no_vote unless current_user

        believable.opinion_of_graph_user current_user.graph_user
      end

      def current_user
        pavlov_options[:current_user]
      end
    end
  end
end
