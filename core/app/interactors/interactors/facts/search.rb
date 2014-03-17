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
        validate_nonempty_string :keywords, keywords
      end

      def authorized?
        can? :index, Fact
      end
    end
  end
end
