require 'pavlov'

module Interactors
  module GlobalFeatures
    class Set
      include Pavlov::Interactor

      arguments :features

      def execute
        command :'global_features/set', features
      end

      def authorized?
        true
      end

      def validate
        raise 'features should be an array' unless @features.is_a? Array
      end
    end
  end
end
