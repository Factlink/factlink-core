module Interactors
  module Facts
    class SocialShare
      include Pavlov::Command
      include Util::CanCan

      arguments :id, :message, :provider_names

      private

      def execute
        if provider_names.include? 'twitter'
          command :'twitter/share_factlink', fact_id: id, message: message
        end

        if provider_names.include? 'facebook'
          command :'facebook/share_factlink', fact_id: id, message: message
        end
      end

      def validate_connected service
        unless can? :share_to, pavlov_options[:current_user].social_account(service)
          errors.add :base, "no #{service} account linked"
        end
      end

      def validate
        validate_connected :twitter if provider_names.include? 'twitter'
        validate_connected :facebook if provider_names.include? 'facebook'
      end

      def authorized?
        can? :share, Fact
      end
    end
  end
end
