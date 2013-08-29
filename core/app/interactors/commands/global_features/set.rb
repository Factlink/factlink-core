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
          #TODO replace sadd feature with sadd array-of-features
          # once we update to redis-rb 3.0 / redis 2.4 which support
          # variadic adds.
        end
      end
    end
  end
end
