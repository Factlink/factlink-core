module Commands
  module TextSearch
    class IndexTopic
      include Pavlov::Command

      arguments :topic, :changed

      def execute
        old_command :'text_search/index',
                      topic, :topic,
                      [:title, :slug_title],
                      changed
      end

      def validate
        validate_not_nil :topic, topic
      end
    end
  end
end
