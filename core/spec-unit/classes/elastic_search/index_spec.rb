require 'pavlov_helper'
require_relative '../../../app/classes/elastic_search.rb'

describe ElasticSearch::Index do
  include PavlovSupport

  before do
    stub_classes 'HTTParty', 'FactlinkUI::Application'
  end

  describe '#delete' do
    it 'sends a delete request to the elasticsearch server' do
      user_id = 14
      url = 'localhost:9200'
      FactlinkUI::Application.stub config: double(elasticsearch_url: url)

      index = ElasticSearch::Index.new('user')

      HTTParty.should_receive(:delete).with("http://#{url}/user/#{user_id}")

      index.delete user_id
    end
  end

end

