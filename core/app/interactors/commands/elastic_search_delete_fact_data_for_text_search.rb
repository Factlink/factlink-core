module Commands
  class ElasticSearchDeleteFactDataForTextSearch
    include Pavlov::Command
    arguments :object

    def execute
      ElasticSearch::Index.new('factdata').delete object.id
    end
  end
end
