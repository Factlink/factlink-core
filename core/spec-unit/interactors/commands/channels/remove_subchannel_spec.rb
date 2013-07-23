require 'pavlov_helper'

require_relative '../../../../app/interactors/commands/channels/remove_subchannel'

describe Commands::Channels::RemoveSubchannel do
  include PavlovSupport
  describe '.execute' do
    before do
      stub_classes 'Resque', 'RemoveChannelFromChannel'
    end
    it 'adds a subchannel to the channel' do
      channel = mock :channel, id: mock, created_by: mock
      subchannel = mock :subchannel, id: mock

      command = described_class.new channel: channel, subchannel: subchannel

      channel.should_receive(:remove_channel).with(subchannel)
             .and_return(true)

      Resque.should_receive(:enqueue)
            .with(RemoveChannelFromChannel, subchannel.id, channel.id)

      expect(command.execute).to eq true
    end
    it 'does not queue jobs or create activities when the removal fails' do
      channel = mock :channel
      subchannel = mock :subchannel

      command = described_class.new channel: channel, subchannel: subchannel

      channel.should_receive(:remove_channel).with(subchannel)
             .and_return(false)

      Resque.should_not_receive(:enqueue)

      expect(command.execute).to eq false
    end
  end
end
