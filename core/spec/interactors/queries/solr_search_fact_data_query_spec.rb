require_relative '../interactor_spec_helper'
require File.expand_path('../../../../app/interactors/queries/solr_search_fact_data_query.rb', __FILE__)

describe SolrSearchFactDataQuery do
  def fake_class
    Class.new
  end

  before do
    stub_const 'Sunspot', fake_class
    stub_const 'FactData', fake_class
  end

  it 'intializes' do
    query = SolrSearchFactDataQuery.new 'this is fun', 1, 20

    query.should_not be_nil
  end

  it '.execute correcly' do
    keywords = 'searching for evidence'
    interactor = SolrSearchFactDataQuery.new keywords, 1, 20

    fact_data = stub()
    results = [fact_data]

    internal_result = mock()
    internal_result.stub hits: results
    internal_result.stub results: results

    Sunspot.should_receive(:search).
      with(FactData).
      and_return(internal_result)

    interactor.execute.should eq results
  end
end
