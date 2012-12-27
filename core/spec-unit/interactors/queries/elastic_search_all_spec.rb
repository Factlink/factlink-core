require 'pavlov_helper'
require_relative '../../../app/interactors/queries/elastic_search_all.rb'

describe Queries::ElasticSearchAll do
  include PavlovSupport

  before do
    stub_classes 'HTTParty', 'FactData', 'User',
                 'Topic', 'FactlinkUI::Application'
  end

  it 'intializes correctly' do
    query = Queries::ElasticSearchAll.new 'interesting search keywords', 1, 20

    query.should_not be_nil
  end

  describe '.call' do
    ['user', 'topic', 'factdata'].each do |type|
      it "correctly with return value of #{type} class" do
        config = mock()
        base_url = '1.0.0.0:4000/index'
        config.stub elasticsearch_url: base_url
        FactlinkUI::Application.stub config: config
        keywords = 'searching for this channel'
        wildcard_keywords = '(searching*%20OR%20searching)+(for*%20OR%20for)+(this*%20OR%20this)+(channel*%20OR%20channel)'
        interactor = Queries::ElasticSearchAll.new keywords, 1, 20

        hit = mock()
        hit.should_receive(:[]).with('_id').and_return(1)
        hit.should_receive(:[]).with('_type').and_return(type)

        results = mock()
        results.stub code: 200
        results.stub parsed_response: { 'hits' => { 'hits' => [ hit ] } }

        HTTParty.should_receive(:get).
          with("http://#{base_url}/factdata,topic,user/_search?q=(searching*+OR+searching)+AND+(for*+OR+for)+AND+(this*+OR+this)+AND+(channel*+OR+channel)&from=0&size=20&analyze_wildcard=true").
          and_return(results)

        return_object = mock()

        case type
        when 'user'
          User.should_receive(:find).
            with(1).
            and_return(return_object)
        when 'topic'
          Topic.should_receive(:find).
            with(1).
            and_return(return_object)
        when 'factdata'
          FactData.should_receive(:find).
            with(1).
            and_return(return_object)
        end

        interactor.call.should eq [return_object]
      end
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
      query = Queries::ElasticSearchAll.new keywords, 1, 20, logger: logger

      expect { query.call }.to raise_error(RuntimeError, error_message)
    end

    it 'url encodes correctly' do
      config = mock()
      base_url = '1.0.0.0:4000/index'
      config.stub elasticsearch_url: base_url
      FactlinkUI::Application.stub config: config
      keywords = '$+,:; @=?&=/'
      wildcard_keywords = '($%5C+,%5C:;*+OR+$%5C+,%5C:;)+AND+(@=%5C?&=/*+OR+@=%5C?&=/)'
      interactor = Queries::ElasticSearchAll.new keywords, 1, 20

      results = mock()
      results.stub code: 200
      results.stub parsed_response: { 'hits' => { 'hits' => [ ] } }

      HTTParty.should_receive(:get).
        with("http://#{base_url}/factdata,topic,user/_search?q=#{wildcard_keywords}&from=0&size=20&analyze_wildcard=true").
        and_return(results)

      interactor.call.should eq []
    end
  end
end
