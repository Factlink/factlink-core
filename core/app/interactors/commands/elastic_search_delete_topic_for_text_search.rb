require_relative 'elastic_search_delete_for_text_search.rb'

module Commands
  class ElasticSearchDeleteTopicForTextSearch < ElasticSearchDeleteForTextSearch

    def define_index
      type 'topic'
    end

  end
end
