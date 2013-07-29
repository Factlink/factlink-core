module HashStore
  Entry = Struct.new(:backend) do
    def value?
      not backend.get.nil?
    end

    def get
      raise "no value" unless value?

      symbol_hash = {}
      backend.get.each do |key, value|
        symbol_hash[key.to_sym] = value
      end

      symbol_hash
    end

    def set value
      raise "You cannot set an empty hash" if value == {}
      backend.set value
    end
  end
end
