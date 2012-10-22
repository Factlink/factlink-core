require_relative 'elastic_search_index_for_text_search_command.rb'

module Commands
  class ElasticSearchIndexUserForTextSearch < ElasticSearchIndexForTextSearchCommand
    def define_index
      type 'user'
      field :username
    end
  end
end
