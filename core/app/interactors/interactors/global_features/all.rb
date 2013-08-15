module Interactors
  module GlobalFeatures
    class All
      include Pavlov::Interactor

      arguments

      def execute
        query :'global_features/index'
      end

      def authorized?
        true
      end
    end
  end
end
