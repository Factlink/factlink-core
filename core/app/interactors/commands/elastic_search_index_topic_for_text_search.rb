require_relative 'elastic_search_index_for_text_search'

module Commands
  class ElasticSearchIndexTopicForTextSearch
    include Pavlov::Command

    arguments :topic

    def execute
      old_command :elastic_search_index_for_text_search,
                    topic, :topic,
                    [:title, :slug_title]
    end
  end
end
