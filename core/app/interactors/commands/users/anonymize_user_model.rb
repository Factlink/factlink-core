module Commands
  module Users
    class AnonymizeUserModel
      include Pavlov::Command

      attribute :user_id, String

      private

      def execute
        User.personal_information_fields.each do |field|
          user[field] = User.fields[field].default_val
        end

        user.first_name            = 'anonymous'
        user.last_name             = 'anonymous'
        user.password              = 'some_password_henk_gerard_gerrit'
        user.password_confirmation = 'some_password_henk_gerard_gerrit'

        user.username = anonymous_username
        user.email = "deleted+#{anonymous_username}@factlink.com"
        # TODO: at some point we can use an official invalid address (check RFCs)
        # For now we want to easily see what mails deleted users still get

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
