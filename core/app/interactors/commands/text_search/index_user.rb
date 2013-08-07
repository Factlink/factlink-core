module Commands
  module TextSearch
    class IndexUser
      include Pavlov::Command

      arguments :user, :changed

      def execute
        old_command :'text_search/index',
                      user, :user,
                      [:username, :first_name, :last_name],
                      changed
      end

      def validate
        validate_not_nil :user, user
      end
    end
  end
end
