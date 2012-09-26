require_relative '../interactor_spec_helper'
require File.expand_path('../../../../app/interactors/queries/solr_search_channel_query.rb', __FILE__)

describe SolrSearchChannelQuery do
  def fake_class
    Class.new
  end

  before do
    stub_const 'Topic', fake_class
    stub_const 'Sunspot', fake_class
  end

  it 'initializes' do
    query = SolrSearchChannelQuery.new 'interesting search terms', 1, 20
    query.should_not be_nil
  end

  it '.execute correctly' do
    keywords = 'searching for this channel'
    query = SolrSearchChannelQuery.new keywords, 1, 20
    internal_result = mock()
    results = mock()
    internal_result.stub results: results
    Sunspot.should_receive(:search).
      with(Topic).
      and_return(internal_result)

    query.execute.should equal results
  end
end
