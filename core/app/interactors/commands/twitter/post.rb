require 'pavlov'

module Commands
  module Twitter
    class Post
      include Pavlov::Command

      arguments :username, :message

      private

      def execute
        client.update message
      end

      def validate
        validate_nonempty_string :username, username
        validate_nonempty_string :message, message

        unless user.identities && user.identities['twitter']
          raise Pavlov::ValidationError, 'no twitter account linked'
        end
      end

      def user
        @user ||= query :user_by_username, username
      end

      def client
        @client ||= begin
          credentials = user.identities['twitter']['credentials']
          token  = credentials['token']
          secret = credentials['secret']

          ::Twitter::Client.new oauth_token: token, oauth_token_secret: secret
        end
      end
    end
  end
end
