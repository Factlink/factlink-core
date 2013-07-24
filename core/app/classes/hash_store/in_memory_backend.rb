module HashStore
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
