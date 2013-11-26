module Queries
  module Topics
    class ById
      include Pavlov::Query

      arguments :id

      def execute
        DeadTopic.new topic.slug_title, topic.title
      end

      def topic
        Topic.find id
      end

      def validate
        validate_hexadecimal_string :id, id
      end
    end
  end
end
