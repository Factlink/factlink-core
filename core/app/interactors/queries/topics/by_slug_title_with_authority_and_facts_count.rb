module Queries
  module Topics
    class BySlugTitleWithAuthorityAndFactsCount
      include Pavlov::Query

      arguments :slug_title

      private

      def execute
        topic = old_query :'topics/by_slug_title', slug_title
        old_query :'topics/dead_topic_with_authority_and_facts_count_by_topic', topic
      end

      def validate
        validate_string :slug_title, slug_title
      end
    end
  end
end
