module Commands
  module Users
    class AnonymizeUserModel
      include Pavlov::Command

      attribute :user_id, String

      private

      def execute
        user.first_name = 'anonymous'
        user.last_name = 'anonymous'
        user.location = ''
        user.biography = ''
        user.twitter = ''
        user.identities = {}

        user.username = anonymous_username
        user.email = "deleted+#{anonymous_username}@factlink.com"

        user.save!
      end

      def anonymous_username
        @anonymous_username ||= "anonymous_#{random_string}"
      end

      def random_string
        some_string = user.username + DateTime.now.strftime("%Y%m%d%k%M%S%L")

        Digest::SHA256.new.hexdigest(some_string)[0..9]
      end

      def user
        @user ||= User.find(user_id)
      end
    end
  end
end
