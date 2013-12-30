module Queries
  module UserTopics
    class TopForUser
      include Pavlov::Query

      arguments :user, :limit_topics

      private

      def execute
        topics.take(limit_topics).map(&method(:dead_topic_for_topic))
      end

      def dead_topic_for_topic topic
        DeadUserTopic.new(topic.slug_title, topic.title)
      end

      def topics
        channel_ids.map{ |id| Channel[id] }.compact.map(&:topic).uniq
      end

      def channel_ids
        facts.map(&:channels).map(&:ids).flatten.uniq
      end

      def facts
        user.graph_user.sorted_created_facts.below '+inf', count: 3
      end
    end
  end
end
