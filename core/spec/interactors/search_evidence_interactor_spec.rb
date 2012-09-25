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
    stub_const 'Sunspot', fake_class
    stub_const 'FactData', fake_class
    stub_const 'CanCan::AccessDenied', Class.new(Exception)
    stub_const 'Ability::FactlinkWebapp', fake_class
    stub_const 'SolrSearchFactDataQuery', fake_class
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

  it 'raises when initialized with an empty keywords string' do
    expect { interactor = SearchEvidenceInteractor.new '', '1' }.
      to raise_error(RuntimeError, 'Keywords must not be empty')
  end

  it 'raises when initialized with a fact_id that is not a string' do
    expect { interactor = SearchEvidenceInteractor.new 'key words', nil }.
      to raise_error(RuntimeError, 'Fact_id should be an number.')
  end

  describe :filter_keywords do
    it 'removes words whose length is smaller then 3 characters' do
      interactor = SearchEvidenceInteractor.new 'z hh interessante d blijven', '1', ability: relaxed_ability

      interactor.filter_keywords.should eq "interessante blijven"
    end
  end

  describe :execute do
    it 'raises when executed without any permission' do
      ability = mock()
      ability.stub can?: false
      interactor = SearchEvidenceInteractor.new 'zoeken interessante dingen', '1', ability: ability

      expect { interactor.execute }.to raise_error(CanCan::AccessDenied)
    end

    it 'executes correctly with solr' do
      ability = mock()
      ability.
        should_receive(:can?).
        with(:index, Fact).
        and_return(true)
      ability.
        should_receive(:can?).
        with(:see_feature_elastic_search, Ability::FactlinkWebapp).
        and_return(false)

      keywords = 'zoeken interessante dingen'
      interactor = SearchEvidenceInteractor.new keywords, '1', ability: ability

      fact_data = get_fact_data '2'
      result = [fact_data]
      query = mock()

      query.should_receive(:execute).
        and_return(result)

      SolrSearchFactDataQuery.should_receive(:new).
        with(keywords, 1, 20).
        and_return(query)

      FactData.stub :valid => true

      interactor.execute.should eq result
    end

    it 'shouldn\'t return itself' do
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

    it 'shouldn\'t return invalid results' do
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
