require_relative '../interactor_spec_helper'
require File.expand_path('../../../../app/interactors/commands/elastic_search_delete_fact_data_for_text_search.rb', __FILE__)

describe Commands::ElasticSearchDeleteFactDataForTextSearch do
  let(:fact_data) do
    fact_data = stub()
    fact_data.stub id: 1
    fact_data
  end

  before do
    stub_const('HTTParty', Class.new)
    stub_const('FactlinkUI::Application', Class.new)
  end

  it 'intitializes' do
    command = Commands::ElasticSearchDeleteFactDataForTextSearch.new fact_data

    command.should_not be_nil
  end

  it 'raises when fact_data is not a FactData' do
    expect { command = Commands::ElasticSearchDeleteFactDataForTextSearch.new 'FactData' }.
      to raise_error(RuntimeError, 'factdata missing fields ([:id]).')
  end

  describe '.execute' do
    it 'correctly' do
      url = 'localhost:9200'
      config = mock()
      config.stub elasticsearch_url: url
      FactlinkUI::Application.stub config: config

      HTTParty.should_receive(:delete).with("http://#{url}/factdata/#{fact_data.id}")
      command = Commands::ElasticSearchDeleteFactDataForTextSearch.new fact_data

      command.execute
    end
  end

end

