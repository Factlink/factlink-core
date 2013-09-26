module Commands
  module Users
    class MarkAsDeleted
      include Pavlov::Command

      arguments :user

      private

      def validate
        raise Pavlov::ValidationError if !user.is_a? User
      end

      def execute
        user.deleted = true
        user.save!
      end
    end
  end
end
