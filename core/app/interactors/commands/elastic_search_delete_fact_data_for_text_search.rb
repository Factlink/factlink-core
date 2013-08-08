require_relative 'elastic_search_delete_for_text_search.rb'

module Commands
  class ElasticSearchDeleteFactDataForTextSearch < ElasticSearchDeleteForTextSearch

    def execute
      @type_name = 'factdata'
      super
    end

  end
end
