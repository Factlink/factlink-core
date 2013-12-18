module Queries
  module Topics
    class DeadTopicWithStatisticsByTopic
      include Pavlov::Query

      arguments :alive_topic

      private

      def execute
        DeadTopic.new alive_topic.slug_title,
                      alive_topic.title,
                      facts_count,
                      favouritours_count
      end

      def facts_count
        query(:'topics/facts_count', slug_title: alive_topic.slug_title)
      end

      def favouritours_count
        query(:'topics/favouritours_count', topic_id: alive_topic.id)
      end
    end
  end
end
