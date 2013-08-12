require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/text_search/delete_fact_data.rb'

describe Commands::TextSearch::DeleteFactData do
  include PavlovSupport

  before do
    stub_classes 'ElasticSearch::Index'
  end

  it 'raises when fact_data has no id' do
    expect { described_class.new(object: 'FactData').call }
      .to raise_error
  end

  describe '#call' do
    it 'correctly' do
      fact_data = double id: 1
      url = 'localhost:9200'
      index = double
      ElasticSearch::Index.stub(:new).with('factdata').and_return(index)
      command = described_class.new object: fact_data

      index.should_receive(:delete).with(fact_data.id)

      command.call
    end
  end

end

