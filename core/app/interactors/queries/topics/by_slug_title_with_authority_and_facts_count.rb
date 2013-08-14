module Queries
  module Topics
    class BySlugTitleWithAuthorityAndFactsCount
      include Pavlov::Query

      arguments :slug_title

      private

      def execute
        topic = query :'topics/by_slug_title', slug_title: slug_title
        query :'topics/dead_topic_with_authority_and_facts_count_by_topic', alive_topic: topic
      end

      def validate
        # leaving this for now, this one is called from jbuilder
        # TODO remove when called from interactor
        validate_string :slug_title, slug_title
      end
    end
  end
end
