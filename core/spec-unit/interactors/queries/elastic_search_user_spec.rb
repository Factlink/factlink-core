require 'pavlov_helper'
require_relative '../../../app/interactors/queries/elastic_search_user.rb'

describe Queries::ElasticSearchUser do
  include PavlovSupport

  before do
    stub_classes 'HTTParty', 'User', 'FactlinkUI::Application', 'FactlinkUser'
  end

  it 'initializes' do
    query = Queries::ElasticSearchUser.new 'interesting search keywords', 1, 20

    query.should_not be_nil
  end

  describe '.call' do
    it 'executes correctly with return value of User class' do
      config = mock
      base_url = '1.0.0.0:4000/index'
      config.stub elasticsearch_url: base_url
      FactlinkUI::Application.stub config: config
      keywords = 'searching for users'
      wildcard_keywords = '(searching*+OR+searching)+AND+(for*+OR+for)+AND+(users*+OR+users)'
      interactor = Queries::ElasticSearchUser.new keywords, 1, 20
      hit = mock
      mongoid_user = mock()
      results = mock
      results.stub parsed_response: { 'hits' => { 'hits' => [ hit ] } }
      results.stub code: 200
      user = mock

      hit.should_receive(:[]).with('_id').and_return(1)
      hit.should_receive(:[]).with('_type').and_return('user')
      HTTParty.should_receive(:get).
        with("http://#{base_url}/user/_search?q=#{wildcard_keywords}&from=0&size=20&analyze_wildcard=true").
        and_return(results)
      User.should_receive(:find).with(1).and_return(mongoid_user)
      FactlinkUser.should_receive(:map_from_mongoid).with(mongoid_user).and_return(user)

      interactor.call.should eq [user]
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
      logger = mock()
      error_message = "Server error, status code: 501, response: '#{error_response}'."

      query = Queries::ElasticSearchUser.new keywords, 1, 20, logger: logger

      HTTParty.should_receive(:get).
        and_return(results)
      logger.should_receive(:error).with(error_message)

      expect { query.call }.to raise_error(RuntimeError, error_message)
    end

    it 'url encodes keywords' do
      config = mock()
      base_url = '1.0.0.0:4000/index'
      config.stub elasticsearch_url: base_url
      FactlinkUI::Application.stub config: config
      keywords = '$+,:; @=?&=/'
      wildcard_keywords = '($%5C+,%5C:;*+OR+$%5C+,%5C:;)+AND+(@=%5C?&=/*+OR+@=%5C?&=/)'
      interactor = Queries::ElasticSearchUser.new keywords, 1, 20
      hit = mock()
      results = mock()
      results.stub parsed_response: { 'hits' => { 'hits' => [ hit ] } }
      results.stub code: 200
      mongoid_user = mock
      user = mock

      hit.should_receive(:[]).with('_id').and_return(1)
      hit.should_receive(:[]).with('_type').and_return('user')
      HTTParty.should_receive(:get).
        with("http://#{base_url}/user/_search?q=#{wildcard_keywords}&from=0&size=20&analyze_wildcard=true").
        and_return(results)
      User.should_receive(:find).with(1).and_return(mongoid_user)
      FactlinkUser.should_receive(:map_from_mongoid).with(mongoid_user).and_return(user)

      interactor.call.should eq [user]
    end
  end
end
