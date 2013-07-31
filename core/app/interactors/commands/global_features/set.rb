require 'pavlov'

module Commands
  module GlobalFeatures
    class Set
      include Pavlov::Command

      arguments :features

      def execute
        redis_set = Nest.new(:admin_global_features)
        redis_set.del
        features.each do |feature|
          redis_set.sadd feature
        end
      end
    end
  end
end
