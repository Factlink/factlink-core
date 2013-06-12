module Queries
  module Facts
    class SharingUrl
      include Pavlov::Query

      arguments :fact

      def execute
        fact.proxy_scroll_url || friendly_fact_url
      end

      def validate
        validate_not_nil :fact, fact
      end

      def friendly_fact_url
        slug = query :"facts/slug", fact, nil
        frurl_fact_url(slug, fact.id)
      end
    end
  end
end
