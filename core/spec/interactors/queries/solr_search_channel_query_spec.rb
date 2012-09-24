require File.expand_path('../../../../app/interactors/queries/solr_search_channel_query.rb', __FILE__)

describe 'SolrSearchChannelQuery' do
  def fake_class
    Class.new
  end

  before do
    stub_const 'Topic', fake_class
    stub_const 'Sunspot', fake_class
  end

  it 'initializes' do
    query = SolrSearchChannelQuery.new 'interesting search terms'
    query.should_not be_nil
  end

  it 'executes correctly' do
    keywords = "searching for this channel"
    query = SolrSearchChannelQuery.new keywords
    internal_result = mock()
    Sunspot.should_receive(:search).
      with(Topic).
      and_return(internal_result)

    query.execute.should equal internal_result
  end
end
