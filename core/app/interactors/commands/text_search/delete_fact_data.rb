module Commands
  module TextSearch
    class DeleteFactData
      include Pavlov::Command
      arguments :object

      def execute
        ElasticSearch::Index.new('factdata').delete object.id
      end
    end
  end
end
