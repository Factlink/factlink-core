require_relative 'elastic_search_index_for_text_search'

module Commands
  class ElasticSearchIndexUserForTextSearch < ElasticSearchIndexForTextSearch
    def fields
      [:username, :first_name, :last_name]
    end

    def type_name
      :user
    end
  end
end
