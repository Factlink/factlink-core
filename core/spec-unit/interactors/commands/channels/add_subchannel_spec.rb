require 'pavlov_helper'

require_relative '../../../../app/interactors/commands/channels/add_subchannel'

describe Commands::Channels::AddSubchannel do
  include PavlovSupport
  before do
    stub_classes 'Channel::Activities',
                 'Commands::Channels::AddFactsFromChannelToChannel'
  end
  describe '.call' do
    it 'adds a subchannel to the channel' do
      channel = mock :channel, created_by: mock
      subchannel = mock :subchannel

      command = Commands::Channels::AddSubchannel.new(channel, subchannel)

      channel.should_receive(:add_channel).with(subchannel)
             .and_return(true)

      command.should_receive(:command)
             .with(:'channels/add_facts_from_channel_to_channel',
                     subchannel, channel)
             .and_return mock call: nil

      expect(command.call).to eq true
    end
    it 'stops execution when the addition is unsuccesful' do
      channel = mock :channel, created_by: mock
      subchannel = mock :subchannel

      command = Commands::Channels::AddSubchannel.new(channel, subchannel)

      channel.stub(:add_channel).with(subchannel).and_return(false)

      command.should_not_receive(:command)
             .with(:'channels/add_facts_from_channel_to_channel',
                     subchannel, channel)

      expect(command.call).to eq false
    end
  end
end
