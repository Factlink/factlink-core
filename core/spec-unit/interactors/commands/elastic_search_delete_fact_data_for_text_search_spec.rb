require 'pavlov_helper'
require_relative '../../../app/interactors/commands/elastic_search_delete_fact_data_for_text_search.rb'

describe Commands::ElasticSearchDeleteFactDataForTextSearch do
  include PavlovSupport

  before do
    stub_classes 'HTTParty', 'FactlinkUI::Application'
  end

  it 'raises when fact_data is not a FactData' do
    expect { Commands::ElasticSearchDeleteFactDataForTextSearch.new('FactData').call }
      .to raise_error
  end

  describe '#call' do
    it 'correctly' do
      fact_data = double id: 1
      url = 'localhost:9200'
      config = double
      config.stub elasticsearch_url: url
      FactlinkUI::Application.stub config: config

      HTTParty.should_receive(:delete).with("http://#{url}/factdata/#{fact_data.id}")
      command = Commands::ElasticSearchDeleteFactDataForTextSearch.new fact_data

      command.call
    end
  end

end

