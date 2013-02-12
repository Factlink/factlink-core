module Queries
  module Sites
    class ForUrl
      include Pavlov::Query

      arguments :url

      def validate
        validate_string :url, @url
      end

      def execute
        @site ||= ::Site.find(url: @url).first
      end
    end
  end
end
