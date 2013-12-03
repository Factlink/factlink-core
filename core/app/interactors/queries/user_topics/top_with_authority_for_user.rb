require_relative '../../../classes/hash_utils'

module Queries
  module UserTopics
    class TopWithAuthorityForUser
      include Pavlov::Query
      include HashUtils

      arguments :user_id, :limit_topics

      private

      def validate
        validate_hexadecimal_string :user_id, user_id
      end

      def execute
        topics.take(limit_topics).map(&method(:dead_topic_for_topic))
      end

      def dead_topic_for_topic topic
        DeadUserTopic.new(topic.slug_title, topic.title)
      end

      def topics
        channel_ids.map(&method(:channel_by_id)).map(&:topic).uniq
      end

      def channel_by_id id
        Channel[id]
      end

      def channel_ids
        facts.map(&:channels).map(&:ids).flatten.uniq
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
