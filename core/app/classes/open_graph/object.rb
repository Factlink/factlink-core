module OpenGraph
  class Object
    attr_accessor :open_graph_hash

    def to_hash
      Hash[@open_graph_hash.map { |key,value| ["og:#{key}", value] }]
    end

    def open_graph_field key, value
      @open_graph_hash ||= {}
      @open_graph_hash[key] = value if value
    end
  end
end
