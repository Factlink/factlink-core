module Queries
  module Facts
    class GetDead
      include Pavlov::Query

      arguments :id

      private

      def execute
        DeadFact.new id:fact.id,
                     site_url: site_url,
                     displaystring: fact.data.displaystring,
                     created_at: fact.data.created_at,
                     site_title: fact.data.title
      end

      def fact
        @fact ||= Fact[id]
      end

      def site_url
        fact.site.url
      end
    end
  end
end
