require 'pavlov'

module Commands
  module GlobalFeatures
    class Set
      include Pavlov::Command

      arguments :features

      def execute
        set.del
        features.each do |feature|
          set.sadd feature
        end
      end

      def set
        Nest.new(:admin_global_features)
      end
    end
  end
end
