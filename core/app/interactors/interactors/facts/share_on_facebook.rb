module Interactors
  module Facts
    class ShareOnFacebook
      include Pavlov::Interactor
      include Util::CanCan

      arguments :fact_id, :message

      def authorized?
        can? :share, Fact
      end

      def execute
        command :'facts/share_on_facebook', fact_id, message
      end

      def validate
        validate_integer_string  :fact_id, fact_id
        validate_nonempty_string :message, message
        validate_not_nil         :current_user, @options[:current_user]
      end
    end
  end
end
