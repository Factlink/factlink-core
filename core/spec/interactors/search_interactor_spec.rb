require_relative 'interactor_spec_helper'
require File.expand_path('../../../app/interactors/search_interactor.rb', __FILE__)

describe SearchInteractor do
  let(:relaxed_ability) do
    ability = mock()
    ability.stub can?: true
    ability
  end

  def fake_class
    Class.new
  end

  before do
    stub_const 'Fact', fake_class
    stub_const 'Queries::ElasticSearchAll', fake_class
    stub_const 'FactData', fake_class
    stub_const 'User', fake_class
    stub_const 'Ability::FactlinkWebapp', fake_class
  end

  it 'initializes' do
    interactor = SearchInteractor.new 'keywords'
    interactor.should_not be_nil
  end

  it 'raises when initialized with keywords that is not a string' do
    expect { interactor = SearchInteractor.new nil, '1' }.
        to raise_error(RuntimeError, 'Keywords should be an string.')
  end

  it 'raises when initialized with an empty keywords string' do
    expect { interactor = SearchInteractor.new '', '1' }.
      to raise_error(RuntimeError, 'Keywords must not be empty.')
  end

  describe '.execute' do
    it 'raises when executed without any permission' do
      ability = mock()
      ability.stub can?: false
      interactor = SearchInteractor.new 'keywords', ability: ability

      expect { interactor.execute }.to raise_error(Pavlov::AccessDenied)
    end

    it 'returns an empty list on keyword with less than two letters.' do
      Queries::ElasticSearchAll.should_not_receive(:execute)
      interactor = SearchInteractor.new 'ke', ability: relaxed_ability

      result = interactor.execute

      result.should eq []
    end

    it 'correctly' do
      keywords = "searching for this channel"
      interactor = SearchInteractor.new keywords, ability: relaxed_ability
      results = ['a','b','c']

      query = mock()
      Queries::ElasticSearchAll.should_receive(:new).
        with(keywords, 1, 20).
        and_return(query)
      query.should_receive(:execute).
        and_return(results)

      interactor.execute.should eq results
    end

    it 'filters keywords with length < 3' do
      keywords = "searching fo this channel"
      filtered_keywords = "searching this channel"
      interactor = SearchInteractor.new keywords, ability: relaxed_ability
      results = ['a','b','c']

      query = mock()
      Queries::ElasticSearchAll.should_receive(:new).
        with(filtered_keywords, 1, 20).
        and_return(query)
      query.should_receive(:execute).
        and_return(results)

      interactor.execute.should eq results
    end

    it 'filters keywords with length < 3 and don''t query because search is empty' do
      keywords = "fo"
      interactor = SearchInteractor.new keywords, ability: relaxed_ability
      Queries::ElasticSearchAll.should_not_receive(:new)

      interactor.execute.should eq []
    end

    it 'invalid Factdata is filtered' do
      keywords = 'searching for this channel'
      interactor = SearchInteractor.new keywords, ability: relaxed_ability
      fact_data = FactData.new
      results =  [fact_data]
      query = mock()
      Queries::ElasticSearchAll.should_receive(:new).
        with(keywords, 1, 20).
        and_return(query)
      query.should_receive(:execute).
        and_return(results)
      FactData.stub invalid: true

      interactor.execute.should eq []
    end

    it 'hidden User is filtered' do
      keywords = 'searching for this channel'
      interactor = SearchInteractor.new keywords, ability: relaxed_ability
      user = User.new
      user.stub hidden: true
      results = [user]

      query = mock()
      Queries::ElasticSearchAll.should_receive(:new).
        with(keywords, 1, 20).
        and_return(query)

      query.should_receive(:execute).
        and_return(results)

      interactor.execute.should eq []
    end
  end
end
