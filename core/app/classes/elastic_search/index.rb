class ElasticSearch
  class Index
    def initialize(name)
      @type_name = name
    end

    def base_url
      "http://#{FactlinkUI::Application.config.elasticsearch_url}/#{@type_name}"
    end

    def add id, json
      HTTParty.put base_url + "/#{id}",
                   { body: json }
    end

    # http://www.elasticsearch.org/guide/reference/api/admin-indices-refresh.html
    def refresh
      HTTParty.post base_url + "/_refresh"
    end
  end
end
