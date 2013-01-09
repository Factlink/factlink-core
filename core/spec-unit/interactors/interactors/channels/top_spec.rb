require_relative '../../../../app/interactors/interactors/channels/top'
require 'pavlov_helper'

describe Interactors::Channels::Top do
  include PavlovSupport

  before do
    Interactors::Channels::Top.any_instance.stub(:authorized?).and_return(true)
  end

  describe '.get_alive_channels' do
    it 'takes a sample of 12 handpicked channels' do
      handpicked_channels = mock
      random_channels = mock

      interactor = Interactors::Channels::Top.new {}
      interactor.should_receive(:handpicked_channels).and_return(handpicked_channels)

      handpicked_channels.should_receive(:sample).with(12).and_return(random_channels)

      expect(interactor.get_alive_channels).to eq random_channels
    end
  end

  describe '.handpicked_channels' do
    before do
      stub_classes 'Channel'
    end

    it 'should retrieve the array of handpicked channels from redis' do
      channel_id = mock
      channel = mock

      handpicked_channel_ids = [channel_id]
      channels = [channel]

      interactor = Interactors::Channels::Top.new {}
      interactor.should_receive(:handpicked_channel_ids).and_return(handpicked_channel_ids)

      Channel.should_receive(:[]).with(channel_id).and_return(channel)

      expect(interactor.handpicked_channels).to eq channels
    end
  end

  describe '.handpicked_channel_ids' do
    before do
      stub_classes 'TopChannels'
    end

    it 'should retrieve an array of handpicked channel ids' do
      top_channels_instance = mock
      channel_ids = mock

      interactor = Interactors::Channels::Top.new {}

      TopChannels.should_receive(:new).and_return(top_channels_instance)
      top_channels_instance.should_receive(:ids).and_return(channel_ids)

      expect(interactor.handpicked_channel_ids).to eq channel_ids
    end
  end
end
