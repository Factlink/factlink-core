require_relative 'elastic_search_index_for_text_search_command'

module Commands
  class ElasticSearchIndexTopicForTextSearch < ElasticSearchIndexForTextSearchCommand
    def define_index
      type 'topic'
      field :title
      field :slug_title
    end
  end
end
