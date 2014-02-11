require 'pavlov_helper'
require 'active_support/core_ext/object/blank'
require_relative '../../../../app/interactors/commands/facts/create'

describe Commands::Facts::Create do
  include PavlovSupport
  before do
    stub_classes 'FactData', 'Fact'
  end

  describe '.create_fact_data' do
    it 'creates a fact data with displaystring, title and returns it' do
      displaystring = 'displaystring'
      title = 'title'
      graph_user = double
      creator = double
      site = double
      command = described_class.new displaystring: displaystring, title: title,
                                    creator: creator, site: site
      fact_data = double

      FactData.should_receive(:new).and_return(fact_data)
      fact_data.should_receive(:displaystring=).with(displaystring)
      fact_data.should_receive(:title=).with(title)
      fact_data.should_receive(:save)

      expect(command.create_fact_data).to eq fact_data
    end
  end

  describe '#call' do
    it 'creates a fact with site and returns it' do
      displaystring = 'displaystring'
      title = 'title'
      graph_user = double
      creator = double(graph_user: graph_user)
      site = double
      command = described_class.new displaystring: displaystring, title: title,
                                    creator: creator, site: site
      fact_data = double
      fact = double(id: double)

      Fact.should_receive(:new).with(site: site).and_return(fact)
      command.should_receive(:create_fact_data).and_return(fact_data)
      fact.should_receive(:data=).with(fact_data)
      fact.should_receive(:data).twice.and_return(fact_data)
      fact.should_receive(:save)
      fact_data.should_receive(:fact_id=).with(fact.id)
      fact_data.should_receive(:save)

      expect(command.execute).to eq fact
    end
  end
end
