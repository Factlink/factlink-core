require_relative '../interactor_spec_helper'
require File.expand_path('../../../../app/interactors/queries/elastic_search_user.rb', __FILE__)

describe Queries::ElasticSearchUser do
  def fake_class
    Class.new
  end

  before do
    stub_const 'HTTParty', fake_class
    stub_const 'User', fake_class
    stub_const 'FactlinkUI::Application', fake_class
  end

  it 'initializes' do
    query = Queries::ElasticSearchUser.new 'interesting search keywords', 1, 20

    query.should_not be_nil
  end

  describe '.execute' do
    it 'executes correctly with return value of User class' do
      config = mock()
      base_url = '1.0.0.0:4000/index'
      config.stub elasticsearch_url: base_url
      FactlinkUI::Application.stub config: config
      keywords = 'searching for users'
      wildcard_keywords = '*searching*+for+*users*'
      interactor = Queries::ElasticSearchUser.new keywords, 1, 20

      hit = mock()
      hit.should_receive(:[]).with('_id').and_return(1)
      hit.should_receive(:[]).with('_type').and_return('user')

      results = mock()
      results.stub parsed_response: { 'hits' => { 'hits' => [ hit ] } }
      results.stub code: 200

      HTTParty.should_receive(:get).
        with("http://#{base_url}/user/_search?q=#{wildcard_keywords}&from=0&size=20&default_operator=AND").
        and_return(results)

      return_object = mock()

      User.should_receive(:find).with(1).and_return(return_object)

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
      query = Queries::ElasticSearchUser.new keywords, 1, 20, logger: logger

      expect { query.execute }.to raise_error(RuntimeError, error_message)
    end

    it 'url encodes keywords' do
      config = mock()
      base_url = '1.0.0.0:4000/index'
      config.stub elasticsearch_url: base_url
      FactlinkUI::Application.stub config: config
      keywords = '$+,:; @=?&=/'
      wildcard_keywords = '*%24%2B%2C%3A%3B*+*%40%3D%3F%26%3D%2F*'
      interactor = Queries::ElasticSearchUser.new keywords, 1, 20

      hit = mock()
      hit.should_receive(:[]).with('_id').and_return(1)
      hit.should_receive(:[]).with('_type').and_return('user')

      results = mock()
      results.stub parsed_response: { 'hits' => { 'hits' => [ hit ] } }
      results.stub code: 200

      HTTParty.should_receive(:get).
        with("http://#{base_url}/user/_search?q=#{wildcard_keywords}&from=0&size=20&default_operator=AND").
        and_return(results)

      return_object = mock()

      User.should_receive(:find).with(1).and_return(return_object)

      interactor.execute.should eq [return_object]
    end
  end
end
