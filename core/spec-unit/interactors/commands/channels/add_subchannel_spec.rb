require 'pavlov_helper'

require_relative '../../../../app/interactors/commands/channels/add_subchannel'

describe Commands::Channels::AddSubchannel do
  include PavlovSupport
  describe '.execute' do
    it 'adds a subchannel to the channel' do
      stub_classes 'Channel::Activities', 'AddChannelToChannel'

      channel = mock :channel, created_by: mock
      subchannel = mock :subchannel

      command = Commands::Channels::AddSubchannel.new(channel, subchannel)

      channel.should_receive(:add_channel).with(subchannel)
             .and_return(true)

      AddChannelToChannel.should_receive(:perform)
                         .with(subchannel, channel)

      command.should_not_receive(:command)

      expect(command.execute).to eq true
    end
    it 'stops execution when the addition is unsuccesful' do
      stub_classes 'Channel::Activities', 'AddChannelToChannel'

      channel = mock :channel, created_by: mock
      subchannel = mock :subchannel

      command = Commands::Channels::AddSubchannel.new(channel, subchannel)

      channel.should_receive(:add_channel).with(subchannel)
             .and_return(false)

      AddChannelToChannel.should_not_receive(:perform)

      command.should_not_receive(:command)

      expect(command.execute).to eq false
    end
  end
end
