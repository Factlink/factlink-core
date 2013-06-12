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
                     proxy_scroll_url
      end

      def fact
        @fact ||= Fact[id]
      end

      def site_url
        return nil unless fact.has_site?

        fact.site.url
      end

      def wheel
        query :'facts/get_dead_wheel', id
      end

      def proxy_scroll_url
        return nil unless fact.has_site?

        FactlinkUI::Application.config.proxy_url + "/?url=" + CGI.escape(fact.site.url) + "&scrollto=" + URI.escape(id)
      end

      def validate
        validate_integer_string :id, id
      end
    end
  end
end
