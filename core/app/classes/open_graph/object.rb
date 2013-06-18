module OpenGraph
  class Object
    def to_hash
      Hash[open_graph_hash.map { |key,value| ["og:#{key}", value] }]
    end

    private

    def open_graph_field key, value
      open_graph_hash[key] = value
    end

    def open_graph_hash
      @open_graph_hash ||= {}
    end
  end
end
