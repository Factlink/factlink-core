module Commands
  module TextSearch
    class IndexFactData
      include Pavlov::Command

      arguments :fact_data, :changed

      def execute
        command(:'text_search/index',
                    object: fact_data, type_name: :factdata,
                    fields: [:displaystring, :title], fields_changed: changed)
      end
    end
  end
end
