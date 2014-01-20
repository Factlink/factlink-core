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
                     votes,
                     fact.deletable?
      end

      def fact
        @fact ||= Fact[id]
      end

      def site_url
        fact.site.url
      end

      def votes
        query(:'believable/votes', believable: fact.believable)
      end
    end
  end
end
