module Commands
  module Users
    class MarkAsDeleted
      include Pavlov::Command

      arguments :user

      def validate
        user.is_a? User
      end

      def execute
        user.deleted = true
        user.save!
      end
    end
  end
end
