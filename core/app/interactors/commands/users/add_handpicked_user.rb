module Commands
  module Users
    class AddHandpickedUser
      include Pavlov::Command

      arguments :user_id

      def execute
        HandpickedTourUsers.new.add user_id
      end
    end
  end
end
