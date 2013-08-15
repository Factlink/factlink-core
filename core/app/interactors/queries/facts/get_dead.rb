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
                     wheel,
                     evidence_count
      end

      def fact
        @fact ||= Fact[id]
      end

      def site_url
        return nil unless fact.has_site?

        fact.site.url
      end

      def wheel
        query(:'facts/get_dead_wheel', id: id)
      end

      def evidence_count
        query(:'evidence/count_for_fact', fact: fact)
      end

      def validate
        validate_integer_string :id, id
      end
    end
  end
end
