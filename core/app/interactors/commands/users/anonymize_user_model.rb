module Commands
  module Users
    class AnonymizeUserModel
      include Pavlov::Command

      attribute :user_id, String

      def execute
        user = User.find(user_id)

        user.first_name = 'anonymous'
        user.last_name = 'anonymous'
        user.email = 'deleted@factlink.com'
        user.location = ''
        user.biography = ''
        user.identities = {}

        user.save!
      end
    end
  end
end
