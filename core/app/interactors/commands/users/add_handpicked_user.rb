module Commands
  module Users
    class AddHandpickedUser
      include Pavlov::Command

      arguments :user_id

      def execute
        HandpickedTourUsers.new.add user_id
      end

      def validate
        validate_hexadecimal_string :user_id, user_id
      end
    end
  end
end
