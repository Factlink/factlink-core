module Commands
  module Users
    class MarkAsDeleted
      include Pavlov::Command
      include Util::Mixpanel

      arguments :user

      private

      def validate
        raise Pavlov::ValidationError if !user.is_a? User
      end

      def execute
        track_user_delete
        user.deleted = true
        user.save!
      end

      def track_user_delete
        mp_track "User: deleted",
          user_id: user.id,
      end
    end
  end
end
