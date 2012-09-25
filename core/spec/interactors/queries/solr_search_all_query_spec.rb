require_relative '../interactor_spec_helper'
require File.expand_path('../../../../app/interactors/queries/solr_search_all_query.rb', __FILE__)

describe SolrSearchAllQuery do
  def fake_class
    Class.new
  end

  before do
    stub_const 'Sunspot', fake_class
    stub_const 'FactData', fake_class
    stub_const 'User', fake_class
    stub_const 'Topic', fake_class
  end

  it 'intializes correctly' do
    query = SolrSearchAllQuery.new 'interesting search keywords', 1, 20

    query.should_not be_nil
  end

  describe '.execute' do
    it 'correcly' do
      keywords = 'searching for this channel'
      interactor = SolrSearchAllQuery.new keywords, 1, 20
      internal_result = mock()
      results = ['a','b','c']
      internal_result.stub hits: results
      internal_result.stub results: results
      Sunspot.should_receive(:search).
        with(FactData, User, Topic).
        and_return(internal_result)

      interactor.execute.should eq results
    end

    it 'logs when index out of sync' do
      keywords = 'searching for this channel'
      mock_logger = mock()
      mock_logger.should_receive(:error)
      interactor = SolrSearchAllQuery.new keywords, 1, 20, logger: mock_logger
      internal_result = mock()
      results = ['a','b','c']
      internal_result.stub hits: ['a','b','c','d']
      internal_result.stub results: results
      Sunspot.stub search: internal_result

      interactor.execute.should eq results
    end
  end
end
