require_relative './entry.rb'

module HashStore
  class Redis
    def initialize(namespace = 'RedisHashStoreNamespace')
      @namespace = namespace
    end

    def [](*args)
      namespace = args.join '::'

      Entry.new(RedisBackend.new(@namespace + "::" + namespace))
    end
  end

  class RedisBackend
    def initialize(key)
      @key = key
    end

    def get
      if redis_hash.keys.length > 0
        redis_hash
      else
        nil
      end
    end

    def set value
      redis.mapped_hmset @key, value
    end

    private

    def redis_hash
      @redis_hash ||= redis.hgetall(@key)
    end

    def redis
      ::Redis.current
    end
  end
end
