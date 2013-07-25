require_relative './entry.rb'

module HashStore
  class InMemory
    def initialize(namespace = 'RedisHashStoreNamespace')
      @namespace = namespace
      @hash = {}
    end

    def [](*args)
      key = @namespace + ":" + args.join(':')
      @hash[key] ||= Entry.new(InMemoryBackend.new(key))
    end
  end

  class InMemoryBackend
    def initialize(key)
    end

    def get
      @value
    end

    def set value
      @value = value
    end
  end
end
