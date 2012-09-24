require File.expand_path('../../../../app/interactors/queries/elastic_search_all_query.rb', __FILE__)

describe 'ElasticSearchAllQuery' do
  let(:fake_class) { Class.new }

  before do
    stub_const 'HTTParty', fake_class
    stub_const 'FactData', fake_class
    stub_const 'User', fake_class
    stub_const 'Topic', fake_class
    stub_const 'FactlinkUI::Application', fake_class
  end

  it 'intializes correctly' do
    query = ElasticSearchAllQuery.new "interesting search keywords", 1, 20

    query.should_not be_nil
  end

  it 'executes correcly' do
    config = mock()
    base_url = "1.0.0.0:4000/index"
    config.stub elasticsearch_url: base_url
    FactlinkUI::Application.stub config: config
    keywords = "searching for this channel"
    interactor = ElasticSearchAllQuery.new keywords, 1, 20
    internal_result = mock()
    results = ['a','b','c']
    internal_result.stub hits: results
    internal_result.stub results: results
    url =
    HTTParty.should_receive(:get).
      with("http://#{base_url}/_search?q=#{keywords}&from=0&size=20").
      and_return(results)

    interactor.execute.should eq results
  end
end
