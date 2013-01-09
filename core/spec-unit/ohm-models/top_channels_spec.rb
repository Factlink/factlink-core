require_relative '../../app/ohm-models/top_channels'

describe TopChannels do
  describe '.ids' do
    it 'returns an array of ids' do
      handpicked_channels_interface = mock
      ids = mock

      top_channels = TopChannels.new

      top_channels.should_receive(:handpicked_channels_interface).and_return(handpicked_channels_interface)
      handpicked_channels_interface.should_receive(:smembers).and_return(ids)

      expect(top_channels.ids).to eq ids
    end
  end

  describe '.add' do
    it 'adds a channel id to the list of handpicked channels' do
      id = 10
      handpicked_channels_interface = mock

      top_channels = TopChannels.new

      top_channels.should_receive(:handpicked_channels_interface).and_return(handpicked_channels_interface)
      handpicked_channels_interface.should_receive(:sadd).with(id)

      top_channels.add(id)
    end
  end

  describe '.handpicked_channels_interface' do
    it 'returns a redis interface to the handpicked channels' do
      nest = mock
      interface = mock

      top_channels = TopChannels.new

      top_channels.should_receive(:redis).and_return(nest)
      nest.should_receive(:[]).with(:handpicked_channels).and_return(interface)

      expect(top_channels.handpicked_channels_interface).to eq interface
    end
  end
end
