module Commands
  module Facts
    class SocialShare
      include Pavlov::Command
      include Util::CanCan

      arguments :fact_id, :message, :provider_names

      private

      def execute
        if provider_names[:twitter]
          Resque.enqueue(Commands::Twitter::ShareFactlink, { fact_id: fact_id, message: message,
            pavlov_options: Util::PavlovContextSerialization.serialize_pavlov_context(pavlov_options) })
        end

        if provider_names[:facebook]
          Resque.enqueue(Commands::Facebook::ShareFactlink, { fact_id: fact_id, message: message,
            pavlov_options: Util::PavlovContextSerialization.serialize_pavlov_context(pavlov_options) })
        end
      end

      def validate_connected service
        unless can? :share_to, pavlov_options[:current_user].social_account(service)
          errors.add :base, "no #{service} account linked"
        end
      end

      def validate
        validate_connected :twitter if provider_names[:twitter]
        validate_connected :facebook if provider_names[:facebook]
      end
    end
  end
end
