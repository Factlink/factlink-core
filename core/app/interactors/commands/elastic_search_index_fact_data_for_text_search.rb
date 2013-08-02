require_relative 'elastic_search_index_for_text_search'

module Commands
  class ElasticSearchIndexFactDataForTextSearch < ElasticSearchIndexForTextSearch
    def define_index
      type 'factdata'
      field :displaystring
      field :title
    end
  end
end
