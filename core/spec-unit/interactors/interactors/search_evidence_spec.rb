require 'pavlov_helper'
require_relative '../../../app/interactors/interactors/search_evidence.rb'

describe Interactors::SearchEvidence do
  include PavlovSupport

  let(:relaxed_ability) { stub(:ability, can?: true)}

  before do
    stub_classes 'Fact', 'FactData', 'Ability::FactlinkWebapp',
                 'Queries::ElasticSearchFactData'
  end

  it 'initializes' do
    interactor = Interactors::SearchEvidence.new 'zoeken interessante dingen', '1', ability: relaxed_ability
    interactor.should_not be_nil
  end

  it 'raises when initialized with keywords that is not a string' do
    expect { interactor = Interactors::SearchEvidence.new nil, '1' }.
      to raise_error(RuntimeError,'Keywords should be an string.')
  end

  it 'raises when initialized with a fact_id that is not a string' do
    expect { interactor = Interactors::SearchEvidence.new 'key words', nil }.
      to raise_error(RuntimeError, 'Fact_id should be an number.')
  end

  describe '.initialize' do
    it 'raises when executed without any permission' do
      ability = stub(:ability, can?: false)
      expect do
        Interactors::SearchEvidence.new 'zoeken interessante dingen', '1', ability: ability
      end.to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '.execute' do
    it 'returns a empty array when the keyword string is empty' do
      keywords = 'zoeken interessante dingen'
      interactor = Interactors::SearchEvidence.new '', '1', ability: relaxed_ability

      interactor.execute.should eq []
    end

    it 'shouldn''t return itself' do
      keywords = 'zoeken interessante dingen'
      interactor = Interactors::SearchEvidence.new keywords, '2', ability: relaxed_ability

      result = [get_fact_data('2')]
      query = mock()

      Queries::ElasticSearchFactData.should_receive(:new).
        with(keywords, 1, 20).
        and_return(query)

      query.should_receive(:execute).
        and_return(result)

      FactData.stub :valid => true

      interactor.execute.should eq []
    end

    it 'correctly' do
      keywords = 'zoeken interessante dingen'
      interactor = Interactors::SearchEvidence.new keywords, '1', ability: relaxed_ability

      result = [get_fact_data('2')]
      query = mock()

      Queries::ElasticSearchFactData.should_receive(:new).
        with(keywords, 1, 20).
        and_return(query)

      query.should_receive(:execute).
        and_return(result)

      FactData.stub :valid => true

      interactor.execute.should eq result
    end

    it 'shouldn''t return invalid results' do
      keywords = 'zoeken interessante dingen'
      interactor = Interactors::SearchEvidence.new keywords, '1', ability: relaxed_ability
      fact_data = get_fact_data '2'
      fact_data2 = get_fact_data '3'

      result = [fact_data, fact_data2]
      query = mock()

      Queries::ElasticSearchFactData.should_receive(:new).
        with('zoeken interessante dingen', 1, 20).
        and_return(query)

      query.should_receive(:execute).
        and_return(result)

      FactData.should_receive(:valid).with(fact_data).and_return(false)
      FactData.should_receive(:valid).with(fact_data2).and_return(true)

      interactor.execute.should eq [fact_data2]
    end
  end

  private
  def get_fact_data id
    fact = mock()
    fact.stub :id => id
    fact_data = mock()
    fact_data.stub :fact => fact

    fact_data
  end
end
