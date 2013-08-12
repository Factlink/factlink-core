module Commands
  module TextSearch
    class DeleteTopic
      include Pavlov::Command
      arguments :object

      def execute
        ElasticSearch::Index.new('topic').delete object.id
      end
    end
  end
end
