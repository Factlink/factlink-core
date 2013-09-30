module Queries
  module Topics
    class ByIdWithStatistics
      include Pavlov::Query

      arguments :id

      private

      def execute
        topic = Topic.find id
        query(:'topics/dead_topic_with_statistics_by_topic',
                  alive_topic: topic)
      end

      def validate
        validate_hexadecimal_string :id, id
      end
    end
  end
end
