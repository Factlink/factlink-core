module Commands
  class ElasticSearchDeleteForTextSearch
    include Pavlov::Command
    arguments :object

    def execute
      raise 'Type_name is not set.' unless @type_name
      ElasticSearch::Index.new(@type_name).delete object.id
    end
  end
end
