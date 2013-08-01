require_relative './generic.rb'
require_relative './entry.rb'

module HashStore
  class Redis < Generic
    def backend key
      RedisBackend.new(key, ::Redis.current)
    end
  end

  private

  RedisBackend = Struct.new(:key, :redis) do
    def get
      if redis_hash != {}
        redis_hash
      else
        nil
      end
    end

    def set value
      redis.mapped_hmset key, value
      @redis_hash = value
    end

    def redis_hash
      @redis_hash ||= redis.hgetall(key)
    end
  end
end
