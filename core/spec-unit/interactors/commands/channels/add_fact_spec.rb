require 'pavlov_helper'
require_relative '../../../../app/ohm-models/channel_facts.rb'
require_relative '../../../../app/interactors/commands/channels/add_fact'

describe Commands::Channels::AddFact do
  include PavlovSupport
  describe '.call' do
    before do
      stub_classes 'Resque', 'AddFactToChannelJob', 'Channel::Activities'
    end

    it 'correctly' do
      fact = mock
      fact_id = mock
      channel = mock
      channel_id = mock
      channel_created_by_id = mock
      sorted_delete_facts = mock
      sorted_internal_facts = mock
      channel_activities = mock

      command = Commands::Channels::AddFact.new fact, channel

      fact.should_receive(:id).and_return fact_id

      Channel::Activities.should_receive(:new)
                         .with(channel).and_return(channel_activities)
      channel_activities.should_receive(:add_created)

      channel.should_receive(:id).and_return channel_id
      channel.should_receive(:sorted_delete_facts).and_return sorted_delete_facts
      channel.should_receive(:sorted_internal_facts).and_return sorted_internal_facts
      channel.should_receive(:created_by_id).and_return channel_created_by_id

      sorted_delete_facts.should_receive(:delete).with(fact)

      sorted_internal_facts.should_receive(:add).with(fact)

      Resque.should_receive(:enqueue).with(AddFactToChannelJob, fact_id, channel_id, initiated_by_id: channel_created_by_id)

      command.call
    end
  end
end
