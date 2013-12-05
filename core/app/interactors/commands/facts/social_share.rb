module Commands
  module Facts
    class SocialShare
      include Pavlov::Command
      include Util::CanCan

      arguments :fact_id, :sharing_options

      private

      def execute
        if sharing_options[:twitter]
          Resque.enqueue(Commands::Twitter::ShareFactlink, { fact_id: fact_id,
            pavlov_options: Util::PavlovContextSerialization.serialize_pavlov_context(pavlov_options) })
        end

        if sharing_options[:facebook]
          Resque.enqueue(Commands::Facebook::ShareFactlink, { fact_id: fact_id,
            pavlov_options: Util::PavlovContextSerialization.serialize_pavlov_context(pavlov_options) })
        end
      end

      def validate_connected service
        unless can? :share_to, pavlov_options[:current_user].social_account(service)
          errors.add :base, "no #{service} account linked"
        end
      end

      def validate
        validate_integer_string :fact_id, fact_id
        validate_connected :twitter if sharing_options[:twitter]
        validate_connected :facebook if sharing_options[:facebook]
      end
    end
  end
end
