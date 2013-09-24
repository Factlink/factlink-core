module Commands
  module Users
    class AnonymizeUserModel
      include Pavlov::Command

      attribute :user_id, String

      def execute
        user = User.find(user_id)
        user.save!
      end
    end
  end
end
