module OpenGraph::Objects
  class OgFact < OpenGraph::Object
    def initialize fact
      open_graph_field :type, "#{facebook_app_namespace}:factlink"
      open_graph_field :url, fact.url.sharing_url
      open_graph_field :title, fact.displaystring
    end

    def facebook_app_namespace
      FactlinkUI::Application.config.andand.facebook_app_namespace
    end
  end
end
