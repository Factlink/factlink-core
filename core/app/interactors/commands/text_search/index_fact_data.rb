module Commands
  module TextSearch
    class IndexFactData
      include Pavlov::Command

      arguments :fact_data, :changed

      def execute
        old_command :'text_search/index',
                      fact_data, :factdata,
                      [:displaystring, :title],
                      changed
      end
    end
  end
end
