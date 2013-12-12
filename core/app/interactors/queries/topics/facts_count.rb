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
    end
  end
end
