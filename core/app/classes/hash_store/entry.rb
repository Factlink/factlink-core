module HashStore
  Entry = Struct.new(:backend) do
    def value?
      not backend.get.nil?
    end

    def get
      raise "no value" unless value?

      hash = {}
      backend.get.each do |k, v|
        hash[k.to_sym] = v
      end

      hash
    end

    def set value
      backend.set value
    end
  end
end
