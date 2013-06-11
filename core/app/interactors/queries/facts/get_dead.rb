module Queries
  module Facts
    class GetDead
      include Pavlov::Query

      arguments :id

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
        if fact.has_site?
          fact.site.url
        else
          nil
        end
      end

      def wheel
        query :'facts/get_dead_wheel', id
      end

      def proxy_scroll_url
        if fact.has_site?
          FactlinkUI::Application.config.proxy_url + "/?url=" + CGI.escape(fact.site.url) + "&scrollto=" + URI.escape(id)
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
