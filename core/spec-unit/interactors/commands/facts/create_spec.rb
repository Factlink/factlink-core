require 'pavlov_helper'
require 'active_support/core_ext/object/blank'
require_relative '../../../../app/interactors/commands/facts/create'

describe Commands::Facts::Create do
  include PavlovSupport

  it '.new' do
    command = Commands::Facts::Create.new 'displaystring', 'title', mock, mock
    command.should_not be_nil
  end

  describe 'validations' do
    let(:subject_class) { Commands::Facts::Create }

    it 'requires displaystring to be a nonempty string' do
      expect_validating('', 'title', mock, mock).
        to fail_validation('displaystring should be a nonempty string.')
    end

    it 'requires title to be a string' do
      expect_validating('displaystring', 1, mock, mock).
        to fail_validation('title should be a string.')
    end

    it 'requires user not to be nil' do
      expect_validating('displaystring', 'title', nil, mock).
        to fail_validation('creator should not be nil.')
    end
  end

  describe '.create_fact_data' do
    before do
      stub_classes 'FactData'
    end

    it 'creates a fact data with displaystring, title and returns it' do
      displaystring = 'displaystring'
      title = 'title'
      graph_user = mock
      creator = mock
      site = mock
      command = Commands::Facts::Create.new displaystring, title, creator, site
      fact_data = mock

      FactData.should_receive(:new).and_return(fact_data)
      fact_data.should_receive(:displaystring=).with(displaystring)
      fact_data.should_receive(:title=).with(title)
      fact_data.should_receive(:save)

      expect(command.create_fact_data).to eq fact_data
    end
  end

  describe '.execute' do
    before do
      stub_classes 'Fact'
    end

    it 'creates a fact with site and returns it' do
      displaystring = 'displaystring'
      title = 'title'
      graph_user = mock
      creator = mock(graph_user: graph_user)
      site = mock
      command = Commands::Facts::Create.new displaystring, title, creator, site
      fact_data = mock
      fact = mock(id: mock)

      Fact.should_receive(:new).with({created_by: graph_user, site: site}).and_return(fact)
      command.should_receive(:create_fact_data).and_return(fact_data)
      fact.should_receive(:data=).with(fact_data)
      fact.should_receive(:data).twice.and_return(fact_data)
      fact.should_receive(:save)
      fact_data.should_receive(:fact_id=).with(fact.id)
      fact_data.should_receive(:save)

      expect(command.execute).to eq fact
    end

    it 'creates a fact with site and returns it' do
      displaystring = 'displaystring'
      title = 'title'
      graph_user = mock
      creator = mock(graph_user: graph_user)
      site = nil
      fact_data = mock
      fact = mock(id: mock)
      command = Commands::Facts::Create.new displaystring, title, creator, site

      Fact.should_receive(:new).with({created_by: graph_user}).and_return(fact)
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
