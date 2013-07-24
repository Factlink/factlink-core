class RedisHashStore
  class HashRetriever
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
      Redis.current
    end
  end

  HashObject = Struct.new(:retriever) do
    def value?
      not value.nil?
    end

    def get
      raise "no value" unless value?

      hash = {}
      value.each do |key, value|
        hash[key.to_sym] = value
      end
      hash
    end

    def set value
      retriever.set value
    end

    private

    def value
      retriever.get
    end

  end

  def initialize(namespace = 'RedisHashStoreNamespace')
    @namespace = namespace
  end

  def [](*args)
    namespace = args.join '::'

    HashObject.new(HashRetriever.new(@namespace + "::" + namespace))
  end
end
