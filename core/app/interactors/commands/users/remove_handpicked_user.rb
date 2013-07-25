require 'pavlov'

module Commands
  module Users
    class RemoveHandpickedUser
      include Pavlov::Command

      arguments :user_id
      attribute :pavlov_options, Hash, default: {}

      def execute
        HandpickedTourUsers.new.remove user_id
      end

      def validate
        validate_hexadecimal_string :user_id, user_id
      end
    end
  end
end
