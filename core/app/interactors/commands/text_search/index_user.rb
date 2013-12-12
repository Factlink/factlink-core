module Commands
  module TextSearch
    class IndexUser
      include Pavlov::Command

      arguments :user, :changed

      def execute
        command(:'text_search/index',
                    object: user, type_name: :user,
                    fields: [:username, :full_name],
                    fields_changed: changed)
      end
    end
  end
end
