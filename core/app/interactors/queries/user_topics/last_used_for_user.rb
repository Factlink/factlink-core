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
        topics.map(&method(:dead_topic_for_topic))
      end

      def dead_topic_for_topic topic
        DeadUserTopic.new(topic.slug_title, topic.title)
      end

      def topics
        facts.map(&:channels).map(&:to_a).flatten.uniq.map(&:topic).uniq
      end

      def facts
        user.graph_user.sorted_created_facts.below '+inf', count: 3
      end

      def user
        User.find(user_id)
      end
    end
  end
end
