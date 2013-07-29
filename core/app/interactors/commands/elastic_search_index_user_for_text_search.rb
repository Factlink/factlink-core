require_relative 'elastic_search_index_for_text_search'

module Commands
  class ElasticSearchIndexUserForTextSearch < ElasticSearchIndexForTextSearch
    def define_index
      type 'user'
      field :username
      field :first_name
      field :last_name
    end
  end
end
