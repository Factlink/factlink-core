module Interactors
  module Facts
    class PostToTwitter
      include Pavlov::Command

      # Let's move this to a query some time...
      include ::FactHelper

      arguments :fact_id, :message

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

      def authorized?
        @options[:current_user]
      end

      private
      def url
        fact.proxy_scroll_url || friendly_fact_url(fact)
      end

      def fact
        @fact ||= query :"facts/get_dead", fact_id
      end

      def maximum_message_length
        140 - short_url_length_https - 1 # -1 for space
      end

      def short_url_length_https
        @short_url_length_https ||= ::Twitter.configuration.short_url_length_https
      end
    end
  end
end
