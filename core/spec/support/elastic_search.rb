require 'httparty'

class ElasticSearch
  def self.clean
    time = Benchmark.realtime do
      delete_index_response = HTTParty.delete "http://#{FactlinkUI::Application.config.elasticsearch_url}/_query?q=*"
      if delete_index_response.code != 404 and delete_index_response.code != 200
        raise 'failed clearing elasticsearch index'
      end
    end
  end

  def self.create
    HTTParty.delete "http://#{FactlinkUI::Application.config.elasticsearch_url}/"

    create_index_response = HTTParty.post "http://#{FactlinkUI::Application.config.elasticsearch_url}/", { body: 'index:\n  number_of_shards:1\n  number_of_replicas:1\n  store:  \n    type:memory' }
    if create_index_response.code != 404 and create_index_response.code != 200
      raise 'failed (re)-creating elasticsearch index'
    end
  end
end
