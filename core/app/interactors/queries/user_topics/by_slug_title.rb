module Queries
  module UserTopics
    class BySlugTitle
      include Pavlov::Query

      arguments :slug_title

      private

      def execute
        topic = query :'topics/by_slug_title', slug_title
        query :'user_topics/by_topic', topic
      end

      def validate
        validate_string :slug_title, slug_title
      end
    end
  end
end
