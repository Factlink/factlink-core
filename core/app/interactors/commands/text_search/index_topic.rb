module Commands
  module TextSearch
    class IndexTopic
      include Pavlov::Command

      arguments :topic

      def execute
        old_command :'text_search/index',
                      topic, :topic,
                      [:title, :slug_title]
      end
    end
  end
end
