require_relative './redis_backend.rb'
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
end
