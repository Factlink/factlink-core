module Commands
  module Facts
    class ShareNew
      include Pavlov::Command

      arguments :fact_id, :share_hash

      def execute
        command :'twitter/share_factlink', fact_id if share_hash[:twitter]
        command :'facebook/share_factlink', fact_id if share_hash[:facebook]
      end

      def share_twitter
        share_hash[:twitter] && @options[:current_user].identities['twitter']
      end

      def share_facebook
        share_hash[:facebook] && @options[:current_user].identities['facebook']
      end

      def validate_connected service
        if !@options[:current_user].identities[service]
          raise Pavlov::ValidationError, "no #{service} account linked"
        end
      end

      def validate
        validate_integer_string :fact_id, fact_id
        validate_connected 'twitter' if share_hash[:twitter]
        validate_connected 'facebook' if share_hash[:facebook]
      end
    end
  end
end
