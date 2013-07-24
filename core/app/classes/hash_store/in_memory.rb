require_relative './in_memory_backend.rb'
require_relative './entry.rb'

module HashStore
  class InMemory
    def initialize(namespace = 'RedisHashStoreNamespace')
      @namespace = namespace
      @hash = {}
    end

    def [](*args)
      key = @namespace + "::" + args.join('::')
      @hash[key] ||= Entry.new(InMemoryBackend.new(key))
    end
  end
end
