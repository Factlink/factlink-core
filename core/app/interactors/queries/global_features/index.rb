require 'pavlov'

module Queries
  module GlobalFeatures
    class Index
      include Pavlov::Query

      arguments

      def execute
        redis_set = Nest.new(:admin_global_features)
        redis_set.smembers
      end
    end
  end
end
