require 'pavlov'

module Commands
  module Facebook
    class ShareFactlink
      include Pavlov::Command

      arguments :message, :fact_id

      private

      def execute
      end

      def token
        @options[:current_user].identities.credentials.token
      end

      def fact
        @fact ||= query :'facts/get_dead', @fact_id
      end

      def validate
        validate_nonempty_string :message, message
        validate_integer_string :fact_id, fact_id
      end
    end
  end
end
