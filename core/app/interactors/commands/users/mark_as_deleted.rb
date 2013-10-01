module Commands
  module Users
    class MarkAsDeleted
      include Pavlov::Command

      arguments :user

      private

      def execute
        user.deleted = true
        user.save!
      end
    end
  end
end
