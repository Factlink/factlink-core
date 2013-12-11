require 'pavlov_helper'
require_relative '../../../../app/ohm-models/channel_facts.rb'
require_relative '../../../../app/interactors/commands/channels/add_fact'

describe Commands::Channels::AddFact do
  include PavlovSupport
  describe '#call' do
    it 'correctly' do
      fact = double id: double, channels: double
      sorted_internal_facts = double
      channel = double :channel,
        id: double,
        created_by_id: double,
        sorted_internal_facts: sorted_internal_facts

      command = Commands::Channels::AddFact.new fact: fact, channel: channel


      sorted_internal_facts.should_receive(:add).with(fact)

      expect(fact.channels)
        .to receive(:add)
        .with(channel)

      command.call
    end
  end
end
