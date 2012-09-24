require File.expand_path('../../../../app/interactors/queries/elastic_search_all_query.rb', __FILE__)

describe 'ElasticSearchAllQuery' do
  def fake_class
    Class.new
  end

  before do
    stub_const 'HTTParty', fake_class
    stub_const 'FactData', fake_class
    stub_const 'User', fake_class
    stub_const 'Topic', fake_class
    stub_const 'FactData', fake_class
    stub_const 'FactlinkUI::Application', fake_class
  end

  it 'intializes correctly' do
    query = ElasticSearchAllQuery.new "interesting search keywords", 1, 20

    query.should_not be_nil
  end

  ['user', 'topic', 'factdata'].each do |type|
    it "executes correctly with return value of #{type} class" do
      config = mock()
      base_url = "1.0.0.0:4000/index"
      config.stub elasticsearch_url: base_url
      FactlinkUI::Application.stub config: config
      keywords = "searching for this channel"
      wildcard_keywords = "*searching* *for* *this* *channel*"
      interactor = ElasticSearchAllQuery.new keywords, 1, 20

      hit = mock()
      hit.should_receive(:[]).with('_id').and_return(1)
      hit.should_receive(:[]).with('_type').and_return(type)

      results = mock()
      results.stub parsed_response: { 'hits' => { 'hits' => [ hit ] } }

      HTTParty.should_receive(:get).
        with("http://#{base_url}/_search?q=#{wildcard_keywords}&from=0&size=20").
        and_return(results)

      return_object = mock()

      case type
      when 'user'
        User.should_receive(:find).
          with(1).
          and_return(return_object)
      when 'topic'
        Topic.should_receive(:find).
          with(1).
          and_return(return_object)
      when 'factdata'
        FactData.should_receive(:find).
          with(1).
          and_return(return_object)
      end

      interactor.execute.should eq [return_object]
    end
  end
end
