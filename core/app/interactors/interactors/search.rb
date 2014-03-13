module Interactors
  class Search
    include Pavlov::Interactor
    include Util::CanCan

    arguments :keywords

    def execute
      row_count = 20 # WARNING: coupling with ReactSearchResults

      results = query :elastic_search_all, keywords: keywords, page: 1, row_count: row_count
      results.reject { |result| invalid_result? result }
    end

    def validate
      fail 'Keywords should be an string.' unless @keywords.kind_of? String
      fail 'Keywords must not be empty.'   unless @keywords.length > 0
    end

    def invalid_result? result
        result.nil? ||
            result.is_a?(FactData) && FactData.invalid(result) ||
            result.respond_to?(:hidden?) && result.hidden?
    end

    def authorized?
      can? :index, Fact
    end
  end
end
