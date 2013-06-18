module Interactors
  module Facts
    class ShareOnFacebook
      include Pavlov::Interactor
      include Util::CanCan

      # How to use this interactor:
      # Pavlov.interactor :'facts/share_on_facebook', :fact_id, :message,
      #                     facebook_app_namespace: FactlinkUI::Application.config.facebook_app_namespace

      arguments :fact_id, :message

      def authorized?
        can? :share, Fact
      end

      def execute
        command :'facebook/share_factlink', fact_id, message
      end

      def validate
        validate_integer_string  :fact_id, fact_id
        validate_nonempty_string :message, message
        validate_not_nil         :current_user, @options[:current_user]
        validate_nonempty_string :facebook_app_namespace,
                                    @options[:facebook_app_namespace]
      end
    end
  end
end
