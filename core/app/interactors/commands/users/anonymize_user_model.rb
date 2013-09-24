module Commands
  module Users
    class AnonymizeUserModel
      include Pavlov::Command

      attribute :user_id, String

      private

      def execute
        user.first_name = 'anonymous'
        user.last_name = 'anonymous'
        user.email = 'deleted@factlink.com'
        user.location = ''
        user.biography = ''
        user.twitter = ''
        user.identities = {}
        user.username = "anonymous_#{random_string}"

        user.save!
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
