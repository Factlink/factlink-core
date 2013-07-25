module Interactors
  module Channels
    class AddFactWithoutPropagation
      include Pavlov::Interactor

      arguments :fact, :channel, :score, :should_add_to_unread
      attribute :pavlov_options, Hash, default: {}

      def execute
        success = execute_actual_addition

        if success
          add_fact_to_topic
          update_unread_facts
          true
        else
          false
        end
      end

      def execute_actual_addition
        old_command :'channels/add_fact_without_propagation', fact, channel, score
      end

      def add_fact_to_topic
        return unless channel.type == 'channel'

        old_command :"topics/add_fact", fact.id, channel.slug_title, score.to_s
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
