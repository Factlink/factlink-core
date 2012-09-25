require File.expand_path('../../../../app/interactors/queries/elastic_search_fact_data_query.rb', __FILE__)

describe 'ElasticSearchFactData' do
  def fake_class
    Class.new
  end

  before do
    stub_const 'HTTParty', fake_class
    stub_const 'FactData', fake_class
    stub_const 'FactlinkUI::Application', fake_class
  end


  it 'initializes' do
    query = ElasticSearchFactDataQuery.new "interesting search keywords", 1, 20

    query.should_not be_nil
  end

  it "executes correctly with return value of FactData class" do
      config = mock()
      base_url = "1.0.0.0:4000/index"
      config.stub elasticsearch_url: base_url
      FactlinkUI::Application.stub config: config
      keywords = "searching for evidence"
      wildcard_keywords = "*searching* *for* *evidence*"
      interactor = ElasticSearchFactDataQuery.new keywords, 1, 20

      hit = mock()
      hit.should_receive(:[]).with('_id').and_return(1)

      results = mock()
      results.stub parsed_response: { 'hits' => { 'hits' => [ hit ] } }

      HTTParty.should_receive(:get).
        with("http://#{base_url}/factdata/_search?q=#{wildcard_keywords}&from=0&size=20").
        and_return(results)

      return_object = mock()

      FactData.should_receive(:find).with(1).and_return(return_object)

      interactor.execute.should eq [return_object]
  end

end

