module Commands
  module Facts
    class ShareNew
      include Pavlov::Command
      include Util::Sanitations
      include Util::CanCan

      arguments :fact_id, :sharing_options

      private

      def execute
        command :'twitter/share_factlink', fact_id if sharing_options[:twitter]
        command :'facebook/share_factlink', fact_id if sharing_options[:facebook]
      end

      def validate_connected service
        unless can? :share_to, service
          raise Pavlov::ValidationError, "no #{service} account linked"
        end
      end

      def validate
        sanitize_boolean_hash :sharing_options

        validate_integer_string :fact_id, fact_id
        validate_connected :twitter if sharing_options[:twitter]
        validate_connected :facebook if sharing_options[:facebook]
      end
    end
  end
end
