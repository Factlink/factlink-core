module Queries
  module Topics
    class BySlugTitle
      include Pavlov::Query

      arguments :slug_title

      def execute
        Topic.by_slug slug_title
      end
    end
  end
end
