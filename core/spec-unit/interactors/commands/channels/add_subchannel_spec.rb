require 'pavlov_helper'

require_relative '../../../../app/interactors/commands/channels/add_subchannel'

describe Commands::Channels::AddSubchannel do
  include PavlovSupport
  describe '.execute' do
    it 'adds a subchannel to the channel' do
      channel = mock :channel
      subchannel = mock :subchannel

      command = Commands::Channels::AddSubchannel.new(channel, subchannel)

      channel.should_receive(:add_channel).with(subchannel)

      command.execute
    end
  end
end
