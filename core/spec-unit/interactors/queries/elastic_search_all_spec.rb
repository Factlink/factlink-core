require 'pavlov_helper'
require_relative '../../../app/interactors/queries/elastic_search_all.rb'

describe Queries::ElasticSearchAll do
  include PavlovSupport

  def fake_class
    Class.new
  end

  before do
    stub_const 'HTTParty', fake_class
    stub_const 'FactData', fake_class
    stub_const 'User', fake_class
    stub_const 'Topic', fake_class
    stub_const 'FactlinkUI::Application', fake_class
  end

  it 'intializes correctly' do
    query = Queries::ElasticSearchAll.new 'interesting search keywords', 1, 20

    query.should_not be_nil
  end

  describe '.execute' do
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
          with("http://#{base_url}/factdata,topic,user/_search?q=#{wildcard_keywords}&from=0&size=20&default_operator=AND").
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

        interactor.execute.should eq [return_object]
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

      expect { query.execute }.to raise_error(RuntimeError, error_message)
    end

    it 'url encodes correctly' do
      config = mock()
      base_url = '1.0.0.0:4000/index'
      config.stub elasticsearch_url: base_url
      FactlinkUI::Application.stub config: config
      keywords = '$+,:; @=?&=/'
      wildcard_keywords = '(%24%2B%2C%3A%3B*%20OR%20%24%2B%2C%3A%3B)+(%40%3D%3F%26%3D%2F*%20OR%20%40%3D%3F%26%3D%2F)'
      interactor = Queries::ElasticSearchAll.new keywords, 1, 20

      results = mock()
      results.stub code: 200
      results.stub parsed_response: { 'hits' => { 'hits' => [ ] } }

      HTTParty.should_receive(:get).
        with("http://#{base_url}/factdata,topic,user/_search?q=#{wildcard_keywords}&from=0&size=20&default_operator=AND").
        and_return(results)

      interactor.execute.should eq []
    end
  end
end
