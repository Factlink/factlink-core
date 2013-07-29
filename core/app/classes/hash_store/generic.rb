module HashStore
  class Generic
    def initialize(namespace = 'some_namespace')
      @namespace = namespace
    end

    def [](*args)
      key = @namespace + ":" + args.join(':')
      Entry.new(backend(key))
    end

    def backend key
      raise NotImplementedError,
        "Subclass #{self.class.name} of HashStore::Generic " +
          "does not implement backend"
    end
  end
end
