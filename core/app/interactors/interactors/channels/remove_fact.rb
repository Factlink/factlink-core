module Interactors
  module Channels
    class RemoveFact
      include Pavlov::Interactor

      arguments :fact, :channel

      def execute
        channel.sorted_internal_facts.delete(fact)
        fact.channels.delete(channel)
      end

      def authorized?
        # TODO use cancan
        return false unless pavlov_options[:current_user]

        pavlov_options[:current_user].graph_user_id == channel.created_by_id
      end
    end
  end
end
