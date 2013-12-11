module Commands
  module Users
    class RemoveHandpickedUser
      include Pavlov::Command

      arguments :user_id

      def execute
        HandpickedTourUsers.new.remove user_id
      end
    end
  end
end
