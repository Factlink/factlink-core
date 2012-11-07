require 'pavlov_helper'
require File.expand_path('../../../app/interactors/search_user_interactor.rb', __FILE__)

describe SearchUserInteractor do
  include PavlovSupport

  let(:relaxed_ability) do
    ability = mock()
    ability.stub can?: true
    ability
  end

  before do
    stub_classes 'Topic', 'Queries::ElasticSearchUser',
                 'Fact','Ability::FactlinkWebapp'
  end

  it 'initializes' do
    interactor = SearchUserInteractor.new 'keywords', ability: relaxed_ability
    interactor.should_not be_nil
  end

  it 'raises when initialized with keywords that is not a string' do
    expect { interactor = SearchUserInteractor.new nil }.
      to raise_error(RuntimeError, 'Keywords should be a string.')
  end

  it 'raises when initialized with an empty keywords string' do
    expect { interactor = SearchUserInteractor.new '' }.
      to raise_error(RuntimeError, 'Keywords must not be empty.')
  end

  describe '.initialize' do
    it 'raises when executed without any permission' do
      keywords = "searching for this user"
      ability = mock()
      ability.stub can?: false

      expect do
        SearchUserInteractor.new keywords, ability: ability
      end.to raise_error(Pavlov::AccessDenied)
    end
  end
  describe '.execute' do
    it 'correctly' do
      keywords = 'searching for this user'
      interactor = SearchUserInteractor.new keywords, ability: relaxed_ability
      topic = mock()
      query = mock()
      query.should_receive(:execute).
        and_return([topic])
      Queries::ElasticSearchUser.should_receive(:new).
        with(keywords, 1, 20).
        and_return(query)

      interactor.execute.should eq [topic]
    end

    it 'filters keywords with length < 2' do
      keywords = 'searching f this user'
      filtered_keywords = 'searching this user'
      interactor = SearchUserInteractor.new keywords, ability: relaxed_ability
      topic = mock()
      query = mock()
      query.should_receive(:execute).
        and_return([topic])
      Queries::ElasticSearchUser.should_receive(:new).
        with(filtered_keywords, 1, 20).
        and_return(query)

      interactor.execute.should eq [topic]
    end

    it 'filters keywords with length < 2 and don''t query because search is empty' do
      keywords = 'f'
      interactor = SearchUserInteractor.new keywords, ability: relaxed_ability

      Queries::ElasticSearchUser.should_not_receive(:new)

      interactor.execute.should eq []
    end
  end
end
