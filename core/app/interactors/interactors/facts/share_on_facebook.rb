module Interactors
  module Facts
    class ShareOnFacebook
      include Pavlov::Interactor
      include Util::CanCan

      # TODO: rewrite this to use Console once we also have a facebook_app_namespace
      # in pavlov_options in ApplicationController
      # How to use this interactor:
      # Pavlov.interactor :'facts/share_on_facebook', '10',
      #                     current_user: user,
      #                     ability: Ability.new(user),
      #                     facebook_app_namespace: FactlinkUI::Application.config.facebook_app_namespace

      arguments :fact_id

      def authorized?
        can? :share, Fact
      end

      def execute
        old_command :'facebook/share_factlink', fact_id
      end

      def validate
        validate_integer_string  :fact_id, fact_id
        validate_not_nil         :current_user, pavlov_options[:current_user]
        validate_nonempty_string :facebook_app_namespace,
                                    pavlov_options[:facebook_app_namespace]
      end
    end
  end
end
