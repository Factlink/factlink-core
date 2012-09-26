require_relative 'interactor_spec_helper'
require File.expand_path('../../../app/interactors/index_user_for_text_search.rb', __FILE__)

describe IndexUserForTextSearch do
  def fake_class
    Class.new
  end

  let(:user) do
    user = stub()
    user.stub id: 1,
              username: 'codinghorror'
    user
  end

  before do
    stub_const('HTTParty', fake_class)
    stub_const('FactlinkUI::Application', fake_class)
  end

  it 'intitializes' do
    interactor = IndexUserForTextSearch.new user

    interactor.should_not be_nil
  end

  it 'raises when user is not a User' do
    expect { interactor = IndexUserForTextSearch.new 'User' }.
      to raise_error(RuntimeError, 'user missing fields ([:username, :id]).')
  end

  describe '.execute' do
    it 'correctly' do
      url = 'localhost:9200'
      config = mock()
      config.stub elasticsearch_url: url
      FactlinkUI::Application.stub config: config
      url = "http://#{url}/user/#{user.id}"
      HTTParty.should_receive(:put).with(url,
        { body: { username: user.username }.to_json})
      interactor = IndexUserForTextSearch.new user

      interactor.execute
    end
  end
end
