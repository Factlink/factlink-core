module Interactors
  module Channels
    class AddFactWithoutPropagation
      include Pavlov::Interactor

      arguments :fact, :channel, :score, :should_add_to_unread

      def execute
        return false unless should_execute?

        add_fact_to_channel
        add_fact_to_topic
        update_unread_facts

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

      def add_fact_to_channel
        channel.sorted_cached_facts.add(fact, score)
        fact.channels.add(channel) if channel.type == 'channel'
      end

      def add_fact_to_topic
        command :"topics/add_fact", fact.id, channel.slug_title, score.to_s
      end

      def update_unread_facts
        return unless should_add_to_unread
        return if fact_created_by_channel_owner?

        add_to_unread_facts
      end

      def add_to_unread_facts
        channel.unread_facts.add(fact)
      end

      def fact_created_by_channel_owner?
        channel.created_by_id == fact.created_by_id
      end

      def authorized?
        true
      end
    end
  end
end
