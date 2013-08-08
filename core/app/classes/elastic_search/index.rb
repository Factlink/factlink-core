class ElasticSearch
  class Index
    def initialize(name)
      @name = name
    end

    def base_url
      ElasticSearch.url + "/#{@name}"
    end

    def add id, json_able
      HTTParty.put base_url + "/#{id}",
                   { body: json_able.to_json }
      ElasticSearch.refresh if ElasticSearch.synchronous
    end
  end
end

