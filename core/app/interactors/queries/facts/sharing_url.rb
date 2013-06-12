module Queries
  module Facts
    class SharingUrl
      include Pavlov::Query
      include ::FactHelper

      arguments :fact

      def execute
        fact.proxy_scroll_url || friendly_fact_url(fact)
      end

      def validate
        validate_not_nil :fact, fact
      end
    end
  end
end
