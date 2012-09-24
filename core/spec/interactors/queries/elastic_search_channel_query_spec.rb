require File.expand_path('../../../../app/interactors/queries/elastic_search_channel_query.rb', __FILE__)

describe 'ElasticSearchChannelQuery' do
  def fake_class
    Class.new
  end

  before do
    stub_const 'Topic', fake_class
    stub_const 'HTTParty', fake_class
    stub_const 'FactlinkUI::Application', fake_class
  end

  it 'initializes' do
    query = ElasticSearchChannelQuery.new 'interesting search terms'
    query.should_not be_nil
  end

  it 'executes correctly' do
    config = mock()
    base_url = "1.0.0.0:4000/index"
    config.stub elasticsearch_url: base_url
    FactlinkUI::Application.stub config: config
    keywords = "searching for this channel"
    wildcard_keywords = "*searching* *for* *this* *channel*"
    query = ElasticSearchChannelQuery.new keywords
    hit = mock()
    hit.should_receive(:[]).with('_id').and_return(1)
    results = mock()
    results.stub parsed_response: { 'hits' => { 'hits' => [ hit ] } }
    url = 'test'
    HTTParty.should_receive(:get).
      with("http://#{base_url}/topic/_search?q=#{wildcard_keywords}").
      and_return(results)
    return_object = mock()
    Topic.should_receive(:find).
      with(1).
      and_return(return_object)
    query.execute.should eq [return_object]
  end
end
