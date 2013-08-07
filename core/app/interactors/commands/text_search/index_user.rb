module Commands
  module TextSearch
    class IndexUser
      include Pavlov::Command

      arguments :user, :fields_changes

      def execute
        old_command :elastic_search_index_for_text_search,
                      user, :user,
                      [:username, :first_name, :last_name]
      end
    end
  end
end
