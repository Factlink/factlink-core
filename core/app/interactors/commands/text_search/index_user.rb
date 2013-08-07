module Commands
  module TextSearch
    class IndexUser
      include Pavlov::Command

      arguments :user, :fields_changes

      def execute
        old_command :'text_search/index',
                      user, :user,
                      [:username, :first_name, :last_name]
      end
    end
  end
end
