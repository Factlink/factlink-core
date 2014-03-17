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
      validate_nonempty_string :keywords, keywords
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
