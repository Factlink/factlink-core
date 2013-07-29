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

  private

  InMemoryBackend = Struct.new(:key, :hash) do
    def get
      hash[key]
    end

    def set value
      hash[key] = value
    end
  end
end
