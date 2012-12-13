require 'pavlov_helper'
require_relative '../../../app/interactors/queries/elastic_search_fact_data.rb'

describe Queries::ElasticSearchFactData do
  include PavlovSupport

  before do
    stub_classes 'HTTParty', 'FactData', 'FactlinkUI::Application'
  end

  it 'initializes' do
    query = Queries::ElasticSearchFactData.new 'interesting search keywords', 1, 20

    query.should_not be_nil
  end

  it 'raises when initialized with an empty keywords string' do
    expect { interactor = Queries::ElasticSearchFactData.new '', 1, 20 }.
      to raise_error(RuntimeError, 'Keywords must not be empty')
  end

  describe '.execute' do
    it 'executes correctly with return value of FactData class' do
      config = mock()
      base_url = '1.0.0.0:4000/index'
      config.stub elasticsearch_url: base_url
      FactlinkUI::Application.stub config: config
      keywords = 'searching for evidence'
      wildcard_keywords = '(searching*+OR+searching)+AND+(for*+OR+for)+AND+(evidence*+OR+evidence)'
      interactor = Queries::ElasticSearchFactData.new keywords, 1, 20

      hit = mock()
      hit.should_receive(:[]).with('_id').and_return(1)
      hit.should_receive(:[]).with('_type').and_return('factdata')

      results = mock()
      results.stub parsed_response: { 'hits' => { 'hits' => [ hit ] } }
      results.stub code: 200

      HTTParty.should_receive(:get).
        with("http://#{base_url}/factdata/_search?q=#{wildcard_keywords}&from=0&size=20&analyze_wildcard=true").
        and_return(results)

      return_object = mock()

      FactData.should_receive(:find).with(1).and_return(return_object)

      interactor.execute.should eq [return_object]
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
      query = Queries::ElasticSearchFactData.new keywords, 1, 20, logger: logger

      expect { query.execute }.to raise_error(RuntimeError, error_message)
    end

    it 'url encodes keywords' do
      config = mock()
      base_url = '1.0.0.0:4000/index'
      config.stub elasticsearch_url: base_url
      FactlinkUI::Application.stub config: config
      keywords = '$+,:; @=?&=/'
      wildcard_keywords = '($%5C+,%5C:;*+OR+$%5C+,%5C:;)+AND+(@=%5C?&=/*+OR+@=%5C?&=/)'
      interactor = Queries::ElasticSearchFactData.new keywords, 1, 20

      hit = mock()
      hit.should_receive(:[]).with('_id').and_return(1)
      hit.should_receive(:[]).with('_type').and_return('factdata')

      results = mock()
      results.stub parsed_response: { 'hits' => { 'hits' => [ hit ] } }
      results.stub code: 200

      HTTParty.should_receive(:get).
        with("http://#{base_url}/factdata/_search?q=#{wildcard_keywords}&from=0&size=20&analyze_wildcard=true").
        and_return(results)

      return_object = mock()

      FactData.should_receive(:find).with(1).and_return(return_object)

      interactor.execute.should eq [return_object]
    end
  end
end
