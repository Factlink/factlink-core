module Commands
  module TextSearch
    class IndexUser
      include Pavlov::Command

      arguments :user, :changed

      def execute
        command(:'text_search/index',
                    object: user, type_name: :user,
                    fields: [:username, :first_name, :last_name],
                    fields_changed: changed)
      end

      def validate
        validate_not_nil :user, user
      end
    end
  end
end
