module Commands
  module Channels
    class AddFactWithoutPropagation
      include Pavlov::Command
      arguments :fact, :channel, :score, :pavlov_options
      def execute
        return false unless should_execute?
        channel.sorted_cached_facts.add(fact,score)
        fact.channels.add channel if channel.type == 'channel'
        true
      end

      def should_execute?
        not(already_propagated or already_deleted)
      end

      def already_propagated
        channel.sorted_cached_facts.include?(fact)
      end

      def already_deleted
        channel.sorted_delete_facts.include?(fact)
      end
    end
  end
end
