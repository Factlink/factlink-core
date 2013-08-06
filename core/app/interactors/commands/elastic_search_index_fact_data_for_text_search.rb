require_relative 'elastic_search_index_for_text_search'

module Commands
  class ElasticSearchIndexFactDataForTextSearch
    include Pavlov::Command

    arguments :factdata

    def execute
      old_command :elastic_search_index_for_text_search,
                    factdata, :factdata,
                    [:displaystring, :title]
    end

  end
end
