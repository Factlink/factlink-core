module OpenGraph::Objects
  class OgFact < OpenGraph::Object
    def initialize fact
      open_graph_field :type, 'factlinkdevelopment:factlink'
      open_graph_field :url, fact.proxy_scroll_url || fact.url
      open_graph_field :title, fact.displaystring
    end
  end
end
