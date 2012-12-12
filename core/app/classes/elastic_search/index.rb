class ElasticSearch
  class Index
    def initialize(name)
      @name = name
    end

    def base_url
      ElasticSearch.url + "/#{@name}"
    end

    def add id, json

      url = base_url + "/#{id}"
      HTTParty.put url,
                   { body: json }

      puts "url: #{url}, id: #{id}, json: #{json}"
      refresh if ElasticSearch.synchronous
    end

    # http://www.elasticsearch.org/guide/reference/api/admin-indices-refresh.html
    def refresh
      refresh_url = ElasticSearch.url + "/_refresh"
      response = HTTParty.post refresh_url
      unless response["ok"]
        raise "Something went wrong while refreshing #{refresh_url}: #{response}"
      end
    end
  end
end

