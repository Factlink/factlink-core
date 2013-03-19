require 'pavlov_helper'

require_relative '../../../../app/interactors/commands/channels/remove_subchannel'

describe Commands::Channels::RemoveSubchannel do
  include PavlovSupport
  describe '.execute' do
    it 'adds a subchannel to the channel' do
      channel = mock :channel
      subchannel = mock :subchannel

      command = Commands::Channels::RemoveSubchannel.new(channel, subchannel)

      channel.should_receive(:remove_channel).with(subchannel)

      command.execute
    end
  end
end
