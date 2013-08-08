require_relative 'elastic_search_delete_for_text_search.rb'

module Commands
  class ElasticSearchDeleteUserForTextSearch < ElasticSearchDeleteForTextSearch

    def execute
      @type_name = 'user'
      super
    end
  end
end
