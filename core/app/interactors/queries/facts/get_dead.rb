module Queries
  module Facts
    class GetDead
      include Pavlov::Query

      arguments :id

      private

      def execute
        DeadFact.new fact.id,
                     site_url,
                     fact.data.displaystring,
                     fact.data.created_at,
                     fact.data.title,
                     fact.deletable?
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
