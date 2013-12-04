require 'pavlov_helper'
require_relative '../../../../app/ohm-models/channel_facts.rb'
require_relative '../../../../app/interactors/commands/channels/add_fact'

describe Commands::Channels::AddFact do
  include PavlovSupport
  describe '#call' do
    before do
      stub_classes 'AddFactToChannelJob', 'Channel::Activities'
    end

    it 'correctly' do
      fact = double id: double
      sorted_internal_facts = double
      channel = double :channel,
        id: double,
        created_by_id: double,
        sorted_internal_facts: sorted_internal_facts
      channel_activities = double

      command = Commands::Channels::AddFact.new fact: fact, channel: channel

      allow(Channel::Activities)
        .to receive(:new)
        .with(channel)
        .and_return(channel_activities)
      expect(channel_activities).to receive(:add_created)

      sorted_internal_facts.should_receive(:add).with(fact)

      expect(AddFactToChannelJob)
        .to receive(:perform)
        .with(fact.id, channel.id)

      command.call
    end
  end
end
