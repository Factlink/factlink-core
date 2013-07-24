require 'pavlov_helper'
require_relative '../../../app/interactors/commands/elastic_search_index_fact_data_for_text_search.rb'

describe Commands::ElasticSearchIndexFactDataForTextSearch do
  include PavlovSupport

  let(:fact_data) do
    double(id: 1, displaystring: 'displaystring', title: 'title')
  end

  before do
    stub_classes 'HTTParty', 'FactlinkUI::Application'
  end

  describe 'validations' do
    it 'raises when fact_data is not a FactData' do
      command = described_class.new(object: 'FactData')

      expect { command.call }
        .to raise_error(RuntimeError, 'factdata missing fields ([:displaystring, :title, :id]).')
    end
  end

  describe '#call' do
    it 'correctly' do
      url = 'localhost:9200'
      config = mock()
      config.stub elasticsearch_url: url
      FactlinkUI::Application.stub config: config
      url = "http://#{url}/factdata/#{fact_data.id}"
      command = described_class.new(object: fact_data)
      json_document = mock

      command.should_receive(:json_document).and_return(json_document)
      HTTParty.should_receive(:put).with(url,
        { body:json_document})

      command.call
    end
  end
end
