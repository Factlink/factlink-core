require 'httparty'

require_relative 'elastic_search/index'

class ElasticSearch
  def self.url
    "http://#{FactlinkUI::Application.config.elasticsearch_url}"
  end

  def self.synchronous
    false
  end

  # http://www.elasticsearch.org/guide/reference/api/admin-indices-refresh.html
  def self.refresh
    refresh_url = ElasticSearch.url + "/_refresh"
    response = HTTParty.post refresh_url
    unless response["ok"]
      raise "Something went wrong while refreshing #{refresh_url}: #{response}"
    end
  end

  def self.clean
    delete_index_response = HTTParty.delete url + "/_query?q=*"
    if delete_index_response.code != 404 and delete_index_response.code != 200
      raise 'failed clearing elasticsearch index'
    end
    self.refresh
  end

  def self.create
    HTTParty.delete url

    create_index_response = HTTParty.post url,
      { body: payload }

    if create_index_response.code != 404 and create_index_response.code != 200
      raise 'failed (re)-creating elasticsearch index'
    end
  end

  def self.payload
    if Rails.env == "test"
      '{
        "index": {
          "number_of_shards": 1,
          "number_of_replicas": 1,
          "store": {
            "type": "memory"
          },
          "analysis": {
            "analyzer": {
              "default": {
                "type": "standard",
                "stopwords": [""]
                }
              }
            }
          }
        }
      }'
    else
      '{
        "index": {
          "analysis": {
            "analyzer": {
              "default": {
                "type": "standard",
                "stopwords": [""]
                }
              }
            }
          }
        }
      }'
    end
  end
end
