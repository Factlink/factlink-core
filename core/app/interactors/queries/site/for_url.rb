module Queries
  module Site
    class ForUrl
      include Pavlov::Query

      arguments :url

      def validate
        validate_string :url, @url
      end

      def execute
        KillObject.site site if site
      end

      def site
        @site ||= ::Site.find(url: @url).first
      end
    end
  end
end
