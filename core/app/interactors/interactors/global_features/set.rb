module Interactors
  module GlobalFeatures
    class Set
      include Pavlov::Interactor
      include Util::CanCan

      arguments :features

      def execute
        Backend::GlobalFeatures.set features
      end

      def authorized?
        can? :configure, Ability::FactlinkWebapp
      end

      def validate
        fail 'features should be an array' unless features.is_a? Array
      end
    end
  end
end
