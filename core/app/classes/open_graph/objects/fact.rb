module OpenGraph::Objects
  class Fact < OpenGraph::Object
    def initialize fact
      open_graph_field :type, 'factlinkdevelopment:factlink'
      open_graph_field :url, fact.url
      open_graph_field :title, fact.displaystring
      open_graph_field :see_also, fact.proxy_scroll_url
    end
  end
end
