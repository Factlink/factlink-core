require_relative '../../../../app/interactors/queries/channels/handpicked'
require 'pavlov_helper'

describe Queries::Channels::Handpicked do
  include PavlovSupport

  before do
    Queries::Channels::Handpicked.any_instance.stub(:authorized?).and_return(true)
  end

  describe '.execute' do
    it 'should return the non_dead_handpicked_channels' do
      non_dead_handpicked_channels = mock

      query = Queries::Channels::Handpicked.new {}
      query.should_receive(:non_dead_handpicked_channels).and_return(non_dead_handpicked_channels)

      expect(query.execute).to eq non_dead_handpicked_channels
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

      query = Queries::Channels::Handpicked.new {}
      query.should_receive(:handpicked_channel_ids).and_return(handpicked_channel_ids)

      Channel.should_receive(:[]).with(channel_id).and_return(channel)

      expect(query.execute).to eq channels
    end
  end

  describe '.non_dead_handpicked_channels' do
    it 'should remove all channels that are nil' do
      channel = mock
      handpicked_channels = [channel, nil]
      non_dead_handpicked_channels = [channel]

      query = Queries::Channels::Handpicked.new {}
      query.should_receive(:handpicked_channels).and_return(handpicked_channels)
      channel.should_receive(:nil?).and_return(false)

      expect(query.non_dead_handpicked_channels).to eq non_dead_handpicked_channels
    end
  end

  describe '.handpicked_channel_ids' do
    before do
      stub_classes 'TopChannels'
    end

    it 'should retrieve an array of handpicked channel ids' do
      top_channels_instance = mock
      channel_ids = mock

      query = Queries::Channels::Handpicked.new {}

      TopChannels.should_receive(:new).and_return(top_channels_instance)
      top_channels_instance.should_receive(:ids).and_return(channel_ids)

      expect(query.handpicked_channel_ids).to eq channel_ids
    end
  end
end
