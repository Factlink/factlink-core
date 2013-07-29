require_relative './generic.rb'
require_relative './entry.rb'

module HashStore
  class InMemory < Generic
    def backend key
      InMemoryBackend.new(key, store_hash)
    end

    def store_hash
      @hash ||= {}
    end
  end

  class InMemoryBackend
    def initialize(key, hash={})
      @hash = hash
      @key = key
    end

    def get
      @hash[@key]
    end

    def set value
      @hash[@key] = value
    end
  end
end
