module Queries
  module Site
    class ForUrl
      include Pavlov::Query

      arguments :url

      def validate
        validate_string :url, @url
      end

      def execute
        ::Site.find(url: @url).first
      end

    end
  end
end
