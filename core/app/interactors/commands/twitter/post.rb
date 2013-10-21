module Commands
  module Twitter
    class Post
      include Pavlov::Command

      arguments :message

      private

      def execute
        client.update message
      end

      def validate
        validate_nonempty_string :message, message

        unless social_account.persisted?
          errors.add :base, 'no twitter account linked'
        end
      end

      def user
        pavlov_options[:current_user]
      end

      def client
        @client ||= ::Twitter::Client.new oauth_token: social_account.token,
                                          oauth_token_secret: social_account.secret
      end

      def social_account
        user.social_account('twitter')
      end
    end
  end
end
