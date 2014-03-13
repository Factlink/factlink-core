module Interactors
  module Facts
    class Search
      include Pavlov::Interactor
      include Util::CanCan

      arguments :keywords

      def execute
        query :elastic_search_fact_data, keywords: keywords, page: 1, row_count: 20
      end

      def validate
        fail 'Keywords should be a string.' unless keywords.kind_of? String
        fail 'Keywords should not be empty' if keywords.length == 0
      end

      def authorized?
        can? :index, Fact
      end
    end
  end
end
