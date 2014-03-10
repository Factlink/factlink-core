module Backend
  module GlobalFeatures
    extend self

    def all
      redis_set.smembers
    end

    def set(features)
      redis_set.del
      features.each do |feature|
        redis_set.sadd feature
        #TODO replace sadd feature with sadd array-of-features
        # once we update to redis-rb 3.0 / redis 2.4 which support
        # variadic adds.
      end
    end

    private

    def redis_set
      Nest.new(:admin_global_features)
    end
  end
end
