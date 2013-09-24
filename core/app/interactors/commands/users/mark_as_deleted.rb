module Commands
  module Users
    class MarkAsDeleted
      include Pavlov::Command

      arguments :user

      def validate
        user.is_a? User
      end

      def execute

      end
    end
  end
end
