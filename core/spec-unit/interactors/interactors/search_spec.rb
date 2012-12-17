require 'pavlov_helper'
require_relative '../../../app/interactors/interactors/search.rb'

describe Interactors::Search do
  include PavlovSupport

  let(:relaxed_ability) { stub(:ability, can?: true)}

  before do
    stub_classes 'Fact', 'Queries::ElasticSearchAll', 'FactData',
                 'User', 'Ability::FactlinkWebapp'
  end

  it 'initializes' do
    interactor = Interactors::Search.new 'keywords', ability: relaxed_ability
    interactor.should_not be_nil
  end

  it 'raises when initialized with keywords that is not a string' do
    expect { interactor = Interactors::Search.new nil, '1' }.
        to raise_error(RuntimeError, 'Keywords should be an string.')
  end

  it 'raises when initialized with an empty keywords string' do
    expect { interactor = Interactors::Search.new '', '1' }.
      to raise_error(RuntimeError, 'Keywords must not be empty.')
  end

  describe '.call' do
    it 'raises when called without any permission' do
      ability = stub(:ability, can?: false)
      expect do
        Interactors::Search.new 'keywords', ability: ability
      end.to raise_error(Pavlov::AccessDenied)
    end
  end
  describe '.call' do
    it 'correctly' do
      keywords = "searching for this channel"
      interactor = Interactors::Search.new keywords, ability: relaxed_ability
      results = ['a','b','c']

      query = mock()
      Queries::ElasticSearchAll.should_receive(:new).
        with(keywords, 1, 20).
        and_return(query)
      query.should_receive(:call).
        and_return(results)

      interactor.call.should eq results
    end

    it 'invalid Factdata is filtered' do
      keywords = 'searching for this channel'
      interactor = Interactors::Search.new keywords, ability: relaxed_ability
      fact_data = FactData.new
      results =  [fact_data]
      query = mock()
      Queries::ElasticSearchAll.should_receive(:new).
        with(keywords, 1, 20).
        and_return(query)
      query.should_receive(:call).
        and_return(results)
      FactData.stub invalid: true

      interactor.call.should eq []
    end

    it 'hidden User is filtered' do
      keywords = 'searching for this channel'
      interactor = Interactors::Search.new keywords, ability: relaxed_ability
      user = User.new
      user.stub hidden: true
      results = [user]

      query = mock()
      Queries::ElasticSearchAll.should_receive(:new).
        with(keywords, 1, 20).
        and_return(query)

      query.should_receive(:call).
        and_return(results)

      interactor.call.should eq []
    end
  end
end
