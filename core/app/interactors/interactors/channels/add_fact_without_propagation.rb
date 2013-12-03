module Interactors
  module Channels
    class AddFactWithoutPropagation
      include Pavlov::Interactor

      arguments :fact, :channel, :score, :should_add_to_unread

      def execute
        success = execute_actual_addition

        if success
          add_fact_to_topic
          true
        else
          false
        end
      end

      def execute_actual_addition
        command :'channels/add_fact_without_propagation', fact: fact, channel: channel, score: score
      end

      def add_fact_to_topic
        command :"topics/add_fact", fact_id: fact.id, topic_slug_title: channel.slug_title, score: score.to_s
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
