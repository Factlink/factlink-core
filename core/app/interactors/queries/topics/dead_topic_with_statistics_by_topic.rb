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
                      0
      end

      def facts_count
        query(:'topics/facts_count', slug_title: alive_topic.slug_title)
      end
    end
  end
end
