require_relative 'elastic_search_index_for_text_search'

module Commands
  class ElasticSearchIndexUserForTextSearch < ElasticSearchIndexForTextSearch
    def execute
      field :username
      field :first_name
      field :last_name
      super
    end

    def type_name
      :user
    end
  end
end
