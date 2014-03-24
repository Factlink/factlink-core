module Interactors
  module Users
    class GetCurrent
      include Pavlov::Interactor

      private

      def execute
        if pavlov_options[:current_user]
          interactor :'users/get_full', username: pavlov_options[:current_user].username
        else
          interactor :'users/get_non_signed_in'
        end
      end

      def authorized?
        true
      end
    end
  end
end
