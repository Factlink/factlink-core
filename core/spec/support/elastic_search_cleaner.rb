require 'httparty'

class ElasticSearchCleaner
  def self.clean
    delete_index_response = HTTParty.delete "http://#{FactlinkUI::Application.config.elasticsearch_url}/"
    if delete_index_response.code != 404 and delete_index_response.code != 200
      raise 'failed clearing elasticsearch index'
    end
  end
end
