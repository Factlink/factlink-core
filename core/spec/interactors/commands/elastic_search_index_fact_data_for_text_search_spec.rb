require_relative '../interactor_spec_helper'
require File.expand_path('../../../../app/interactors/commands/elastic_search_index_fact_data_for_text_search.rb', __FILE__)

describe Commands::ElasticSearchIndexFactDataForTextSearch do
  def fake_class
    Class.new
  end

  let(:fact_data) do
    fact_data = stub()
    fact_data.stub id: 1,
                   displaystring: 'displaystring',
                   title: 'title'
    fact_data
  end

  before do
    stub_const('HTTParty', fake_class)
    stub_const('FactlinkUI::Application', fake_class)
  end

  it 'intitializes' do
    interactor = Commands::ElasticSearchIndexFactDataForTextSearch.new fact_data

    interactor.should_not be_nil
  end

  it 'raises when fact_data is not a FactData' do
    expect { interactor = Commands::ElasticSearchIndexFactDataForTextSearch.new 'FactData' }.
      to raise_error(RuntimeError, 'factdata missing fields ([:displaystring, :title, :id]).')
  end

  describe '.execute' do
    it 'correctly' do
      url = 'localhost:9200'
      config = mock()
      config.stub elasticsearch_url: url
      FactlinkUI::Application.stub config: config
      url = "http://#{url}/factdata/#{fact_data.id}"
      HTTParty.should_receive(:put).with(url,
        { body: { displaystring: fact_data.displaystring, title: fact_data.title }.to_json})
      interactor = Commands::ElasticSearchIndexFactDataForTextSearch.new fact_data

      interactor.execute
    end
  end
end
