require_relative 'interactor_spec_helper'
require File.expand_path('../../../app/interactors/search_channel_interactor.rb', __FILE__)

describe SearchChannelInteractor do

  let(:relaxed_ability) do
    ability = mock()
    ability.stub can?: true
    ability
  end

  def fake_class
    Class.new
  end

  before do
    class User; end
    @user = User.new
    stub_const 'Topic', fake_class
    stub_const 'CanCan::AccessDenied', Class.new(RuntimeError)
    stub_const 'Queries::ElasticSearchChannel', fake_class
    stub_const 'Fact', fake_class
    stub_const 'Ability::FactlinkWebapp', fake_class
  end

  it 'initializes' do
    interactor = SearchChannelInteractor.new 'keywords', @user
    interactor.should_not be_nil
  end

  it 'raises when initialized with keywords that is not a string' do
    expect { interactor = SearchChannelInteractor.new nil, @user }.
      to raise_error(RuntimeError, 'Keywords should be a string.')
  end

  it 'raises when initialized with an empty keywords string' do
    expect { interactor = SearchChannelInteractor.new '', @user }.
      to raise_error(RuntimeError, 'Keywords must not be empty.')
  end

  it 'raises when initialized with a user that is not a User.' do
    expect { interactor = SearchChannelInteractor.new 'keywords', nil }.
      to raise_error(RuntimeError, 'User should be of User type.')
  end

  describe '.execute' do
    it 'raises when executed without any permission' do
      keywords = "searching for this channel"
      ability = mock()
      ability.stub can?: false
      interactor = SearchChannelInteractor.new keywords, @user, ability: ability

      expect { interactor.execute }.to raise_error(CanCan::AccessDenied)
    end

    it 'correctly' do
      keywords = 'searching for this channel'
      interactor = SearchChannelInteractor.new keywords, @user, ability: relaxed_ability
      topic = mock()
      query = mock()
      query.should_receive(:execute).
        and_return([topic])
      Queries::ElasticSearchChannel.should_receive(:new).
        with(keywords, 1, 20).
        and_return(query)

      interactor.execute.should eq [topic]
    end

    it 'filters keywords with length < 2' do
      keywords = 'searching f this channel'
      filtered_keywords = 'searching this channel'
      interactor = SearchChannelInteractor.new keywords, @user, ability: relaxed_ability
      topic = mock()
      query = mock()
      query.should_receive(:execute).
        and_return([topic])
      Queries::ElasticSearchChannel.should_receive(:new).
        with(filtered_keywords, 1, 20).
        and_return(query)

      interactor.execute.should eq [topic]
    end

    it 'filters keywords with length < 2 and don''t query because search is empty' do
      keywords = 'f'
      interactor = SearchChannelInteractor.new keywords, @user, ability: relaxed_ability

      Queries::ElasticSearchChannel.should_not_receive(:new)

      interactor.execute.should eq []
    end
  end
end
