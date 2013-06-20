module OpenGraph
  class Object
    def to_hash
      open_graph_hash
    end

    private

    def open_graph_field key, value
      raise "Graph fied requires value" unless value
      open_graph_hash["og:#{key}"] = value
    end

    def open_graph_hash
      @open_graph_hash ||= {}
    end
  end
end
