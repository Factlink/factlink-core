module Commands
  class ElasticSearchDeleteTopicForTextSearch
    include Pavlov::Command
    arguments :object

    def execute
      ElasticSearch::Index.new('topic').delete object.id
    end
  end
end
