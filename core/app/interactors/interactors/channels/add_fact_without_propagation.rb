module Interactors
  module Channels
    class AddFactWithoutPropagation
      include Pavlov::Interactor

      arguments :fact, :channel, :score

      def execute
        channel.sorted_cached_facts.add(fact, score)
        fact.channels.add(channel) if channel.type == 'channel'
      end

      def authorized?
        true
      end
    end
  end
end
