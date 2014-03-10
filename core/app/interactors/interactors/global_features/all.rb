module Interactors
  module GlobalFeatures
    class All
      include Pavlov::Interactor

      arguments

      def execute
        Backend::GlobalFeatures.all
      end

      def authorized?
        true
      end
    end
  end
end
