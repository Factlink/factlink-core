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
                     fact.deletable?
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

      def validate
        validate_integer_string :id, id
      end
    end
  end
end
