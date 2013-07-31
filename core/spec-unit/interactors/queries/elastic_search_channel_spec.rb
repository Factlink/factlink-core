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

  describe '.call' do
    it 'correctly' do
      config = double
      base_url = "1.0.0.0:4000/index"
      config.stub elasticsearch_url: base_url
      FactlinkUI::Application.stub config: config
      keywords = 'searching for this channel'
      wildcard_keywords = '(searching*+OR+searching)+AND+(for*+OR+for)+AND+(this*+OR+this)+AND+(channel*+OR+channel)'
      query = Queries::ElasticSearchChannel.new keywords, 1, 20
      hit = double
      hit.should_receive(:[]).with('_id').and_return(1)
      hit.should_receive(:[]).with('_type').and_return('topic')
      results = double
      results.stub parsed_response: { 'hits' => { 'hits' => [ hit ] } }
      results.stub code: 200
      url = 'test'
      HTTParty.should_receive(:get).
        with("http://#{base_url}/topic/_search?q=#{wildcard_keywords}&from=0&size=20&analyze_wildcard=true").
        and_return(results)

      return_object = double

      query.stub(:old_query).
        with(:'topics/by_id_with_authority_and_facts_count', 1).
        and_return(return_object)

      query.call.should eq [return_object]
    end

    it 'logs and raises an error when HTTParty returns a non 2xx status code.' do
      config = double
      base_url = '1.0.0.0:4000/index'
      config.stub elasticsearch_url: base_url
      FactlinkUI::Application.stub config: config
      keywords = 'searching for this channel'
      results = double
      error_response = 'error has happened server side'
      results.stub response: error_response
      results.stub code: 501
      HTTParty.should_receive(:get).
        and_return(results)
      logger = double
      error_message = "Server error, status code: 501, response: '#{error_response}'."
      logger.should_receive(:error).with(error_message)
      query = Queries::ElasticSearchChannel.new keywords, 1, 20, logger: logger

      expect { query.call }.to raise_error(RuntimeError, error_message)
    end

    it 'url encodes correctly' do
      config = double
      base_url = '1.0.0.0:4000/index'
      config.stub elasticsearch_url: base_url
      FactlinkUI::Application.stub config: config
      keywords = '$+,:; @=?&=/'
      wildcard_keywords = '($%5C+,%5C:;*+OR+$%5C+,%5C:;)+AND+(@=%5C?&=/*+OR+@=%5C?&=/)'
      query = Queries::ElasticSearchChannel.new keywords, 1, 20
      hit = double
      hit.should_receive(:[]).with('_id').and_return(1)
      hit.should_receive(:[]).with('_type').and_return('topic')
      results = double
      results.stub parsed_response: { 'hits' => { 'hits' => [ hit ] } }
      results.stub code: 200
      url = 'test'
      HTTParty.should_receive(:get).
        with("http://#{base_url}/topic/_search?q=#{wildcard_keywords}&from=0&size=20&analyze_wildcard=true").
        and_return(results)

      query.stub get_object: stub

      query.call
    end
  end
end
