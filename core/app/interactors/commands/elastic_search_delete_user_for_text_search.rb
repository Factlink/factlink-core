module Commands
  class ElasticSearchDeleteUserForTextSearch
    include Pavlov::Command
    arguments :object

    def execute
      ElasticSearch::Index.new('user').delete object.id
    end
  end
end
