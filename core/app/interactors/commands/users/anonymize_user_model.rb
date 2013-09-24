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

        user.first_name = 'Deleted'
        user.last_name  = 'User'

        user.password              = anonymous_password
        user.password_confirmation = anonymous_password

        user.username = anonymous_username
        user.email = "deleted+#{anonymous_username}@factlink.com"
        # TODO: at some point we can use an official invalid address (check RFCs)
        # For now we want to easily see what mails deleted users still get

        user.save!
      end

      def anonymous_username
        @anonymous_username ||= 'anonymous_' + random_string[0..9]
      end

      def anonymous_password
        @anonymous_password ||= random_string
      end

      def random_string
        SecureRandom.hex
      end

      def user
        @user ||= User.find(user_id)
      end
    end
  end
end
