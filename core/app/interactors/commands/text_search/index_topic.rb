module Commands
  module TextSearch
    class IndexTopic
      include Pavlov::Command

      arguments :topic, :changed

      def execute
        command(:'text_search/index',
                    object: topic, type_name: :topic, fields: [:title, :slug_title],
                    fields_changed: changed)
      end
    end
  end
end
