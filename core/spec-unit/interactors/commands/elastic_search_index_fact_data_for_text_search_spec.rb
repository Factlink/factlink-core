require 'pavlov_helper'
require_relative '../../../app/interactors/commands/elastic_search_index_fact_data_for_text_search.rb'

describe Commands::ElasticSearchIndexFactDataForTextSearch do
  include PavlovSupport

  let(:fact_data) do
    fact_data = stub()
    fact_data.stub id: 1,
                   displaystring: 'displaystring',
                   title: 'title'
    fact_data
  end

  before do
    stub_classes 'HTTParty', 'FactlinkUI::Application'
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
