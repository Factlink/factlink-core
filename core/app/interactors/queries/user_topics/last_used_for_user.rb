require_relative '../../../classes/hash_utils'

module Queries
  module UserTopics
    class LastUsedForUser
      include Pavlov::Query
      include HashUtils

      arguments :user_id

      private

      def validate
        validate_hexadecimal_string :user_id, user_id
      end

      def execute
        return [] unless topic

        [DeadUserTopic.new(topic.slug_title, topic.title)]
      end

      def topic
        return nil unless channel

        channel.topic
      end

      def channel
        return nil unless fact

        fact.channels.first
      end

      def fact
        user.graph_user.sorted_created_facts.first
      end

      def user
        User.find(user_id)
      end
    end
  end
end
