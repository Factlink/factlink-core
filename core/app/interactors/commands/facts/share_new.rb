module Commands
  module Facts
    class ShareNew
      include Pavlov::Command
      include Util::Sanitations
      include Util::CanCan

      arguments :fact_id, :sharing_options

      private

      def execute
        if sharing_options[:twitter]
          Resque.enqueue Commands::Twitter::ShareFactlink,
            fact_id, Util::PavlovContextSerialization.serialize_pavlov_context(@options)
        end

        if sharing_options[:facebook]
          Resque.enqueue Commands::Facebook::ShareFactlink,
            fact_id, Util::PavlovContextSerialization.serialize_pavlov_context(@options)
        end
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
