# This command anonymizes a deleted user
# The idea is that this command is idempotent, and can
# be run again and again against deleted users
module Commands
  module Users
    class AnonymizeUserModel
      include Pavlov::Command

      attribute :user_id, String

      private

      def execute
        return unless user.deleted

        User.personal_information_fields.each do |field|
          user[field] = User.fields[field].default_val
        end

        user.full_name = 'Deleted User'

        user.password              = anonymous_password
        user.password_confirmation = anonymous_password

        user.username = anonymous_username
        user.email = "deleted+#{anonymous_username}@factlink.com"
        # TODO: at some point we can use an official invalid address (check RFCs)
        # For now we want to easily see what mails deleted users still get

        user.save!

        user.social_accounts.each do |social_account|
          # TODO: properly deauthorize facebook here
          social_account.destroy
        end
      end

      def anonymous_username
        @anonymous_username ||= 'anonymous_' + SecureRandom.hex[0..9]
      end

      def anonymous_password
        @anonymous_password ||= SecureRandom.hex
      end

      def user
        @user ||= User.find(user_id)
      end
    end
  end
end
