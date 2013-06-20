module Queries
  module UserTopics
    class ById
      include Pavlov::Query

      arguments :id

      private

      def execute
        topic = Topic.find id
        query :'user_topics/by_topic', topic
      end

      def validate
        validate_hexadecimal_string :id, id
      end
    end
  end
end
