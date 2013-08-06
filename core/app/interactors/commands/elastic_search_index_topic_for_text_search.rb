require_relative 'elastic_search_index_for_text_search'

module Commands
  class ElasticSearchIndexTopicForTextSearch < ElasticSearchIndexForTextSearch
    def execute
      field :title
      field :slug_title
      super
    end

    def type_name
      :topic
    end
  end
end
