require_relative 'elastic_search_index_for_text_search'

module Commands
  class ElasticSearchIndexUserForTextSearch
    include Pavlov::Command

    arguments :user

    def execute
      old_command :elastic_search_index_for_text_search,
                    user, :user,
                    [:username, :first_name, :last_name]
    end
  end
end
