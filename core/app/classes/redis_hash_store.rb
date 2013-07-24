class RedisHashStore
  def initialize(key = 'RedisHashStoreNamespace')
    @key = key
  end

  def value?
    redis_hash.keys.length > 0
  end

  def get
    redis_hash or raise "no value"
    hash = {}
    redis_hash.each do |key, value|
      hash[key.to_sym] = value
    end
    hash
  end

  def []=(key, value)
    self[key].set value
  end

  def [](key)
    RedisHashStore.new(@key + "::" + key)
  end

  protected

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
