module Interactors
  module Facts
    class PostToTwitter
      include Pavlov::Interactor
      include Util::CanCan
      include Util::Validations

      arguments :fact_id, :message

      def authorized?
        can? :share, Fact
      end

      private

      def execute
        message_with_url = message + ' ' + url

        old_command :"twitter/post", message_with_url
      end

      def validate
        validate_integer_string  :fact_id, fact_id
        validate_nonempty_string :message, message
        validate_string_length   :message, message, maximum_message_length
        validate_not_nil         :current_user, pavlov_options[:current_user]
      end

      def url
        fact = old_query :"facts/get_dead", fact_id
        ::FactUrl.new(fact).sharing_url
      end

      def maximum_message_length
        short_url_length_https = ::Twitter.configuration.short_url_length_https

        140 - short_url_length_https - 1 # -1 for space
      end
    end
  end
end
