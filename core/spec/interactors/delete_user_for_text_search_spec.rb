require_relative 'interactor_spec_helper'
require File.expand_path('../../../app/interactors/delete_user_for_text_search.rb', __FILE__)

describe DeleteUserForTextSearch do
  def fake_class
    Class.new
  end

  let(:user) do
    user = stub()
    user.stub id: 1
    user
  end

  before do
    stub_const('HTTParty', fake_class)
    stub_const('FactlinkUI::Application', fake_class)
  end

  it 'intitializes' do
    interactor = DeleteUserForTextSearch.new user

    interactor.should_not be_nil
  end

  it 'raises when user is not a User' do
    expect { interactor = DeleteUserForTextSearch.new 'User' }.
      to raise_error(RuntimeError, 'user missing fields ([:id]).')
  end

  describe '.execute' do
    it 'correctly' do
      url = 'localhost:9200'
      config = mock()
      config.stub elasticsearch_url: url
      FactlinkUI::Application.stub config: config

      HTTParty.should_receive(:delete).with("http://#{url}/user/#{user.id}")
      interactor = DeleteUserForTextSearch.new user

      interactor.execute
    end
  end

end

