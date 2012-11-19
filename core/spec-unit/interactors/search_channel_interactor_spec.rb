require 'pavlov_helper'
require_relative '../../app/interactors/search_channel_interactor.rb'

describe SearchChannelInteractor do
  include PavlovSupport

  let(:relaxed_ability) { stub(:ability, can?: true)}

  before do
    stub_classes 'Topic','Queries::ElasticSearchChannel',
                 'Fact','Ability::FactlinkWebapp'
  end

  it 'initializes' do
    interactor = SearchChannelInteractor.new 'keywords', ability: relaxed_ability
    interactor.should_not be_nil
  end

  it 'raises when initialized with keywords that is not a string' do
    expect { interactor = SearchChannelInteractor.new nil }.
      to raise_error(RuntimeError, 'Keywords should be a string.')
  end

  it 'raises when initialized with an empty keywords string' do
    expect { interactor = SearchChannelInteractor.new '' }.
      to raise_error(RuntimeError, 'Keywords must not be empty.')
  end

  describe '.initialize' do
    it 'raises when executed without any permission' do
      keywords = "searching for this channel"
      ability = stub(:ability, can?: false)
      expect do
        SearchChannelInteractor.new keywords, ability: ability
      end.to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '.execute' do
    it 'correctly' do
      keywords = 'searching for this channel'
      interactor = SearchChannelInteractor.new keywords, ability: relaxed_ability
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
      interactor = SearchChannelInteractor.new keywords, ability: relaxed_ability
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
      interactor = SearchChannelInteractor.new keywords, ability: relaxed_ability

      Queries::ElasticSearchChannel.should_not_receive(:new)

      interactor.execute.should eq []
    end
  end
end
