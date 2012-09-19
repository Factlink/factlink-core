require File.expand_path('../../../app/interactors/search_interactor.rb', __FILE__)

describe 'SearchInteractor' do

  let(:relaxed_ability) do
    ability = mock()
    ability.stub can?: true
    ability
  end

  let(:fake_class) { Class.new }

  before do
    stub_const 'CanCan::AccessDenied', Class.new(Exception)
    stub_const 'Fact', fake_class
    stub_const 'Sunspot', fake_class
    stub_const 'FactData', fake_class
    stub_const 'User', fake_class
    stub_const 'Topic', fake_class
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

  describe :filter_keywords do
    it 'removes words whose length is smaller then 3 characters' do
      interactor = SearchInteractor.new 'z hh interessante d blijven', ability: relaxed_ability

      interactor.filter_keywords.should eq "interessante blijven"
    end
  end

  describe :execute do
    it 'raises when executed without any permission' do
      ability = mock()
      ability.stub can?: false
      interactor = SearchInteractor.new 'keywords', ability: ability

      expect { interactor.execute }.to raise_error(CanCan::AccessDenied)
    end

    it 'returns an empty list on keyword with less than two words.' do
      Sunspot.should_not_receive(:search)
      interactor = SearchInteractor.new 'ke', ability: relaxed_ability

      result = interactor.execute

      result.should eq []
    end

    it 'correctly' do
      keywords = "searching for this channel"
      interactor = SearchInteractor.new keywords, ability: relaxed_ability
      internal_result = mock()
      results = ['a','b','c']
      internal_result.stub hits: results
      internal_result.stub results: results
      Sunspot.should_receive(:search).
        with(FactData, User, Topic).
        and_return(internal_result)

      interactor.execute.should eq results
    end

    it 'invalid Factdata is filtered' do
      keywords = "searching for this channel"
      interactor = SearchInteractor.new keywords, ability: relaxed_ability
      fact_data = FactData.new
      internal_result = mock()
      internal_result.stub hits: [fact_data]
      internal_result.stub results: [fact_data]
      Sunspot.should_receive(:search).
        with(FactData, User, Topic).
        and_return(internal_result)

      FactData.stub invalid: true

      interactor.execute.should eq []
    end

    it 'hidden User is filtered' do
      keywords = "searching for this channel"
      interactor = SearchInteractor.new keywords, ability: relaxed_ability
      user = User.new
      user.stub hidden: true
      internal_result = mock()
      internal_result.stub hits: [user]
      internal_result.stub results: [user]
      Sunspot.should_receive(:search).
        with(FactData, User, Topic).
        and_return(internal_result)

      FactData.stub invalid: true

      interactor.execute.should eq []
    end

    # TODO: need a way to inject the logger so you can check the error.
    pending 'index out of sync' do
      keywords = "searching for this channel"
      interactor = SearchInteractor.new keywords, ability: relaxed_ability
      internal_result = mock()
      results = ['a','b','c']
      internal_result.stub hits: results + ['d']
      internal_result.stub results: results
      Sunspot.should_receive(:search).
        with(FactData, User, Topic).
        and_return(internal_result)

      interactor.execute.should eq internal_result
    end
  end
end
