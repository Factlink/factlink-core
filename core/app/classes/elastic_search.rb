require 'httparty'

require_relative 'elastic_search/index'

class ElasticSearch
  def self.url
    "http://#{FactlinkUI::Application.config.elasticsearch_url}"
  end

  def self.synchronous
    false
  end

  def self.clean
    delete_index_response = HTTParty.delete url + "/_query?q=*"
    if delete_index_response.code != 404 and delete_index_response.code != 200
      raise 'failed clearing elasticsearch index'
    end
  end

  def self.create
    HTTParty.delete url

    create_index_response = HTTParty.post url,
       { body: 'index:\n  number_of_shards:1\n  number_of_replicas:1\n  store:  \n    type:memory' }
    if create_index_response.code != 404 and create_index_response.code != 200
      raise 'failed (re)-creating elasticsearch index'
    end
  end
end
