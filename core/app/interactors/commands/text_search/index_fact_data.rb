module Commands
  module TextSearch
    class IndexFactData
      include Pavlov::Command

      arguments :factdata

      def execute
        old_command :elastic_search_index_for_text_search,
                      factdata, :factdata,
                      [:displaystring, :title]
      end
    end
  end
end
