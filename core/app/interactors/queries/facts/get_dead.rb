module Queries
  module Facts
    class GetDead
      include Pavlov::Query

      arguments :id

      def execute
        DeadFact.new fact.id,
                     site_url,
                     fact.data.displaystring,
                     fact.data.created_at
      end

      def fact
        @fact ||= Fact[id]
      end

      def site_url
        if fact.has_site?
          fact.site.url
        else
          nil
        end
      end

      def validate
        validate_integer_string :id, id
      end
    end
  end
end
