require 'pavlov'

module Commands
  module Facebook
    class ShareFactlink
      include Pavlov::Command

      arguments :fact_id, :message

      private

      def execute
        # TODO: Use correct Facebook app here, depending on environment
        client.put_connections("me",
                "factlinkdevelopment:share",
                factlink: fact.url)
      end

      def token
        @options[:current_user].identities['facebook']['credentials']['token']
      end

      def fact
        @fact ||= query :'facts/get_dead', @fact_id
      end

      def client
        ::Koala::Facebook::API.new(token)
      end

      def validate
        validate_nonempty_string :message, message
        validate_integer_string :fact_id, fact_id
        validate_nonempty_string :facebook_app_namespace,
                                  @options[:facebook_app_namespace]
      end
    end
  end
end
