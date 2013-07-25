require 'pavlov'

module Queries
  module GlobalFeatures
    class Index
      include Pavlov::Query

      def execute
        set.smembers
      end

      def set
        Nest.new :admin_global_features
      end
    end
  end
end
