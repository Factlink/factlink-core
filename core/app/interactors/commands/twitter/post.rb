require 'pavlov'

module Commands
  module Twitter
    class Post
      include Pavlov::Command

      arguments :username, :message

      def execute
        client.update message
      end

      def validate
        validate_nonempty_string :username, username
        validate_nonempty_string :message, message
      end

      private
      def user
        query :user_by_username, username
      end

      def client
        token  = credentials['token']
        secret = credentials['secret']
        @client ||= ::Twitter::Client.new oauth_token: token, oauth_token_secret: secret
      end

      def credentials
        unless user.identities && user.identities['twitter']
          raise Pavlov::ValidationError, 'no twitter account linked'
        end

        user.identities['twitter']['credentials']
      end
    end
  end
end
