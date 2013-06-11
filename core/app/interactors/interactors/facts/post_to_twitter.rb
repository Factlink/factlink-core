module Interactors
  module Facts
    class PostToTwitter
      include Pavlov::Command
      include Util::CanCan

      # TODO: Let's move this to a query some time...
      include ::FactHelper

      arguments :fact_id, :message

      def authorized?
        can? :share, Fact
      end

      private

      def execute
        username = @options[:current_user].username
        message_with_url = message + ' ' + url

        command :"twitter/post", username, message_with_url
      end

      def validate
        validate_integer_string :fact_id, fact_id
        validate_nonempty_string :message, message

        if message.length > maximum_message_length
          raise Pavlov::ValidationError,
            "message cannot be longer than #{maximum_message_length} characters"
        end
      end

      def url
        fact.proxy_scroll_url || friendly_fact_url(fact)
      end

      def fact
        @fact ||= query :"facts/get_dead", fact_id
      end

      def maximum_message_length
        short_url_length_https = ::Twitter.configuration.short_url_length_https

        140 - short_url_length_https - 1 # -1 for space
      end
    end
  end
end
