module Interactors
  class SearchEvidence
    include Pavlov::Interactor
    include Util::CanCan
    include Util::Search

    arguments :keywords

    def validate
      fail 'Keywords should be an string.' unless @keywords.kind_of? String
    end

    def use_query
      :elastic_search_fact_data
    end

    def keyword_min_length
      1
    end

    def valid_result? result
      true
    end

    def authorized?
      can? :index, Fact
    end
  end
end
