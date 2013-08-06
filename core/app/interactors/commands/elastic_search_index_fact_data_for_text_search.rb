require_relative 'elastic_search_index_for_text_search'

module Commands
  class ElasticSearchIndexFactDataForTextSearch < ElasticSearchIndexForTextSearch
    def fields
      [:displaystring, :title]
    end

    def type_name
      :factdata
    end
  end
end
