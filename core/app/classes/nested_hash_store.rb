class NestedHashHashStore
  class HashRetriever
    def initialize(key)
    end

    def get
      @value
    end

    def set value
      @value = value
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
    @hash = {}
  end

  def [](*args)
    key = @namespace + "::" + args.join('::')
    @hash[key] ||= HashObject.new(HashRetriever.new(key))
  end
end
