require 'pavlov_helper'

require_relative '../../../../app/interactors/interactors/channels/add_subchannel'

describe Interactors::Channels::AddSubchannel do
  include PavlovSupport
  before do
    stub_classes 'Channel'
  end
  describe '.execute' do
    it 'adds a subchannel to the channel' do
      channel = mock :channel, id:12
      subchannel = mock :subchannel, id:45

      Channel.stub(:[]) do |id|
        if id == channel.id
          channel
        elsif id == subchannel.id
            subchannel
        else
          nil
        end
      end

      interactor = Interactors::Channels::AddSubchannel.new(channel.id, subchannel.id)
      interactor.should_receive(:command).with(:'channels/add_subchannel', channel, subchannel)

      interactor.execute
    end
  end
end
