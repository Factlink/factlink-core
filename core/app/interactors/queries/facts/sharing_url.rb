require_relative '../../../../app/classes/fact_url'

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
        ::FactUrl.new(fact).friendly_fact_url
      end
    end
  end
end
