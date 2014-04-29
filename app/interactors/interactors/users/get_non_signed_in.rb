module Interactors
  module Users
    class GetNonSignedIn
      include Pavlov::Interactor

      private

      def execute
        {
          features: interactor(:'global_features/all')
        }
      end

      def authorized?
        true
      end
    end
  end
end
