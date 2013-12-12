module Queries
  module Sites
    class ForUrl
      include Pavlov::Query

      arguments :url

      def execute
        ::Site.find(url: url).first
      end
    end
  end
end
