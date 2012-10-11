require_relative 'interactor_spec_helper'
require File.expand_path('../../../app/interactors/search_evidence_interactor.rb', __FILE__)

describe SearchEvidenceInteractor do
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
    stub_const 'FactData', fake_class
    stub_const 'CanCan::AccessDenied', Class.new(Exception)
    stub_const 'Ability::FactlinkWebapp', fake_class
    stub_const 'ElasticSearchFactDataQuery', fake_class
  end

  it 'initializes' do
    interactor = SearchEvidenceInteractor.new 'zoeken interessante dingen', '1'
    interactor.should_not be_nil
  end

  it 'raises when initialized with keywords that is not a string' do
    expect { interactor = SearchEvidenceInteractor.new nil, '1' }.
      to raise_error(RuntimeError,'Keywords should be an string.')
  end

  it 'raises when initialized with a fact_id that is not a string' do
    expect { interactor = SearchEvidenceInteractor.new 'key words', nil }.
      to raise_error(RuntimeError, 'Fact_id should be an number.')
  end

  describe '.execute' do
    it 'raises when executed without any permission' do
      ability = mock()
      ability.stub can?: false
      interactor = SearchEvidenceInteractor.new 'zoeken interessante dingen', '1', ability: ability

      expect { interactor.execute }.to raise_error(CanCan::AccessDenied)
    end

    it 'returns a empty array when the keyword string is empty' do
      keywords = 'zoeken interessante dingen'
      interactor = SearchEvidenceInteractor.new '', '1', ability: relaxed_ability

      interactor.execute.should eq []
    end

    it 'shouldn''t return itself' do
      keywords = 'zoeken interessante dingen'
      interactor = SearchEvidenceInteractor.new keywords, '2', ability: relaxed_ability

      result = [get_fact_data('2')]
      query = mock()

      ElasticSearchFactDataQuery.should_receive(:new).
        with(keywords, 1, 20).
        and_return(query)

      query.should_receive(:execute).
        and_return(result)

      FactData.stub :valid => true

      interactor.execute.should eq []
    end

    it 'correctly' do
      keywords = 'zoeken interessante dingen'
      interactor = SearchEvidenceInteractor.new keywords, '1', ability: relaxed_ability

      result = [get_fact_data('2')]
      query = mock()

      ElasticSearchFactDataQuery.should_receive(:new).
        with(keywords, 1, 20).
        and_return(query)

      query.should_receive(:execute).
        and_return(result)

      FactData.stub :valid => true

      interactor.execute.should eq result
    end

    it 'filters keywords with length < 3' do
      keywords = 'zoeken fo interessante dingen'
      filtered_keywords = 'zoeken interessante dingen'
      interactor = SearchEvidenceInteractor.new keywords, '1', ability: relaxed_ability

      result = [get_fact_data('2')]
      query = mock()

      ElasticSearchFactDataQuery.should_receive(:new).
        with(filtered_keywords, 1, 20).
        and_return(query)

      query.should_receive(:execute).
        and_return(result)

      FactData.stub :valid => true

      interactor.execute.should eq result
    end

    it 'filters keywords with length < 3 and don''t query because search is empty' do
      keywords = 'fo'
      interactor = SearchEvidenceInteractor.new keywords, '1', ability: relaxed_ability
      ElasticSearchFactDataQuery.should_not_receive(:new)

      interactor.execute.should eq []
    end

    it 'shouldn''t return invalid results' do
      keywords = 'zoeken interessante dingen'
      interactor = SearchEvidenceInteractor.new keywords, '1', ability: relaxed_ability
      fact_data = get_fact_data '2'
      fact_data2 = get_fact_data '3'

      result = [fact_data, fact_data2]
      query = mock()

      ElasticSearchFactDataQuery.should_receive(:new).
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
