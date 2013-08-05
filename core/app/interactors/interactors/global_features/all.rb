require 'pavlov'

module Interactors
  module GlobalFeatures
    class All
      include Pavlov::Interactor

      arguments

      def execute
        old_query :'global_features/index'
      end

      def authorized?
        true
      end
    end
  end
end