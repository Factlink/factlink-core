require 'pavlov_helper'
require_relative '../../../app/interactors/commands/elastic_search_index_user_for_text_search.rb'

describe Commands::ElasticSearchIndexUserForTextSearch do
  include PavlovSupport

  let(:user) do
    user = stub()
    user.stub id: 1,
              username: 'codinghorror'
    user
  end

  before do
    stub_classes 'HTTParty', 'FactlinkUI::Application'
  end

  it 'intitializes' do
    interactor = Commands::ElasticSearchIndexUserForTextSearch.new user

    interactor.should_not be_nil
  end

  it 'raises when user is not a User' do
    expect { interactor = Commands::ElasticSearchIndexUserForTextSearch.new 'User' }.
      to raise_error(RuntimeError, 'user missing fields ([:username, :id]).')
  end

  describe '.call' do
    it 'correctly' do
      url = 'localhost:9200'
      config = mock()
      config.stub elasticsearch_url: url
      FactlinkUI::Application.stub config: config
      url = "http://#{url}/user/#{user.id}"
      HTTParty.should_receive(:put).with(url,
        { body: { username: user.username }.to_json})
      interactor = Commands::ElasticSearchIndexUserForTextSearch.new user

      interactor.call
    end
  end
end
