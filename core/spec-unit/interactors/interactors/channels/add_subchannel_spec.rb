require 'pavlov_helper'

require_relative '../../../../app/interactors/interactors/channels/add_subchannel'

describe Interactors::Channels::AddSubchannel do
  include PavlovSupport
  before do
    stub_classes 'Channel'
  end
  describe '.execute' do
    let(:channel) { mock :channel, id:'12' }
    let(:subchannel) { mock :subchannel, id:'45' }
    let(:options) { {ability: mock(can?: true)} }
    it 'adds a subchannel to the channel' do
      Channel.stub(:[]) do |id|
        if id == channel.id
          channel
        elsif id == subchannel.id
            subchannel
        else
          nil
        end
      end
      interactor = Interactors::Channels::AddSubchannel.new(channel.id, subchannel.id, options)
      interactor.should_receive(:command).with(:'channels/add_subchannel', channel, subchannel)

      interactor.execute
    end
    it "raises an exception when the channel is not found" do
      Channel.stub(:[]) do |id|
        if id == subchannel.id
          channel
        else
          nil
        end
      end
      expect do
        interactor = Interactors::Channels::AddSubchannel.new(channel.id, subchannel.id, options)
        interactor.execute
      end.to raise_error(RuntimeError, "Channel #{channel.id} not found")
    end
    it "raises an exception when the channel is not found" do
      Channel.stub(:[]) do |id|
        if id == channel.id
          channel
        else
          nil
        end
      end
      expect do
        interactor = Interactors::Channels::AddSubchannel.new(channel.id, subchannel.id, options)
        interactor.execute
      end.to raise_error(RuntimeError, "Channel #{subchannel.id} not found")
    end
  end
end
