require 'pavlov_helper'
require_relative '../../../app/interactors/queries/elastic_search_channel.rb'

describe Queries::ElasticSearchChannel do
  include PavlovSupport

  before do
    stub_classes 'Topic', 'HTTParty', 'FactlinkUI::Application'
  end

  it 'initializes' do
    query = Queries::ElasticSearchChannel.new 'interesting search terms', 1, 20
    query.should_not be_nil
  end

  describe '.execute' do
    it 'correctly' do
      config = mock()
      base_url = "1.0.0.0:4000/index"
      config.stub elasticsearch_url: base_url
      FactlinkUI::Application.stub config: config
      keywords = 'searching for this channel'
      wildcard_keywords = '(searching*%20OR%20searching)+(for*%20OR%20for)+(this*%20OR%20this)+(channel*%20OR%20channel)'
      query = Queries::ElasticSearchChannel.new keywords, 1, 20
      hit = mock()
      hit.should_receive(:[]).with('_id').and_return(1)
      hit.should_receive(:[]).with('_type').and_return('topic')
      results = mock()
      results.stub parsed_response: { 'hits' => { 'hits' => [ hit ] } }
      results.stub code: 200
      url = 'test'
      HTTParty.should_receive(:get).
        with("http://#{base_url}/topic/_search?q=#{wildcard_keywords}&from=0&size=20&default_operator=AND").
        and_return(results)
      return_object = mock()
      Topic.should_receive(:find).
        with(1).
        and_return(return_object)

      query.execute.should eq [return_object]
    end

    it 'logs and raises an error when HTTParty returns a non 2xx status code.' do
      config = mock()
      base_url = '1.0.0.0:4000/index'
      config.stub elasticsearch_url: base_url
      FactlinkUI::Application.stub config: config
      keywords = 'searching for this channel'
      results = mock()
      error_response = 'error has happened server side'
      results.stub response: error_response
      results.stub code: 501
      HTTParty.should_receive(:get).
        and_return(results)
      logger = mock()
      error_message = "Server error, status code: 501, response: '#{error_response}'."
      logger.should_receive(:error).with(error_message)
      query = Queries::ElasticSearchChannel.new keywords, 1, 20, logger: logger

      expect { query.execute }.to raise_error(RuntimeError, error_message)
    end

    it 'url encodes correctly' do
      config = mock()
      base_url = '1.0.0.0:4000/index'
      config.stub elasticsearch_url: base_url
      FactlinkUI::Application.stub config: config
      keywords = '$+,:; @=?&=/'
      wildcard_keywords = '(%24%2B%2C%3A%3B*%20OR%20%24%2B%2C%3A%3B)+(%40%3D%3F%26%3D%2F*%20OR%20%40%3D%3F%26%3D%2F)'
      query = Queries::ElasticSearchChannel.new keywords, 1, 20
      hit = mock()
      hit.should_receive(:[]).with('_id').and_return(1)
      hit.should_receive(:[]).with('_type').and_return('topic')
      results = mock()
      results.stub parsed_response: { 'hits' => { 'hits' => [ hit ] } }
      results.stub code: 200
      url = 'test'
      HTTParty.should_receive(:get).
        with("http://#{base_url}/topic/_search?q=#{wildcard_keywords}&from=0&size=20&default_operator=AND").
        and_return(results)
      return_object = mock()
      Topic.should_receive(:find).
        with(1).
        and_return(return_object)

      query.execute.should eq [return_object]
    end
  end
end
