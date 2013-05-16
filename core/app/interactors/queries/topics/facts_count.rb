module Queries
  module Topics
    class FactsCount
      include Pavlov::Query

      arguments :slug_title

      def execute
        facts_key.zcard
      end

      def facts_key
        Topic.redis[slug_title][:facts]
      end

      def validate
        validate_string :slug_title, slug_title
      end
    end
  end
end
