module Commands
  module Facts
    class ShareNew
      include Pavlov::Command

      arguments :fact_id, :sharing_options

      def execute
        command :'twitter/share_factlink', fact_id if sharing_options[:twitter]
        command :'facebook/share_factlink', fact_id if sharing_options[:facebook]
      end

      def validate_connected service
        if !@options[:current_user].identities[service]
          raise Pavlov::ValidationError, "no #{service} account linked"
        end
      end

      def validate
        validate_integer_string :fact_id, fact_id
        validate_connected 'twitter' if sharing_options[:twitter]
        validate_connected 'facebook' if sharing_options[:facebook]
      end
    end
  end
end
