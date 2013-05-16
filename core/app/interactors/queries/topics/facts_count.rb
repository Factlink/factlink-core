module Queries
  module Topics
    class FactsCount
      include Pavlov::Query

      arguments :slug_title

      def execute
        redis_key.zcard
      end

      def redis_key
        Topic.redis[slug_title][:facts]
      end

      def validate
        validate_string :slug_title, slug_title
      end
    end
  end
end
