require 'pavlov_helper'

require_relative '../../../../app/interactors/commands/channels/add_subchannel'

describe Commands::Channels::AddSubchannel do
  include PavlovSupport
  before do
    stub_classes 'Channel::Activities',
                 'Commands::Channels::AddFactsFromChannelToChannel'
  end
  describe '#call' do
    it 'adds a subchannel to the channel' do
      channel = double :channel, created_by: double
      subchannel = double :subchannel

      command = described_class.new(channel: channel, subchannel: subchannel)

      channel.should_receive(:add_channel).with(subchannel)
             .and_return(true)

      command.should_receive(:old_command)
             .with(:'channels/add_facts_from_channel_to_channel',
                     subchannel, channel)
             .and_return double call: nil

      expect(command.call).to eq true
    end
    it 'stops execution when the addition is unsuccesful' do
      channel = double :channel, created_by: double
      subchannel = double :subchannel

      command = described_class.new(channel: channel, subchannel: subchannel)

      channel.stub(:add_channel).with(subchannel).and_return(false)

      command.should_not_receive(:old_command)
             .with(:'channels/add_facts_from_channel_to_channel',
                     subchannel, channel)

      expect(command.call).to eq false
    end
  end
end
