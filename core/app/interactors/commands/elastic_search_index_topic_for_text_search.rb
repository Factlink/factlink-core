require_relative 'elastic_search_index_for_text_search'

module Commands
  class ElasticSearchIndexTopicForTextSearch < ElasticSearchIndexForTextSearch
    def fields
      [:title, :slug_title]
    end

    def type_name
      :topic
    end
  end
end
