module OpenGraph::Objects
  class OgFact < OpenGraph::Object
    def initialize fact
      open_graph_field :type, 'factlinkdevelopment:factlink'
      open_graph_field :url, fact.url.sharing_url
      open_graph_field :title, fact.displaystring
    end
  end
end
