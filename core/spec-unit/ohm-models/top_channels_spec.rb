require_relative '../../app/ohm-models/top_channels'

describe TopChannels do
  describe '.ids' do
    it 'returns an array of ids' do
      nest = mock
      interface = mock
      ids = mock

      top_channels = TopChannels.new

      top_channels.should_receive(:redis).and_return(nest)
      nest.should_receive(:[]).with(:handpicked_channels).and_return(interface)
      interface.should_receive(:smembers).and_return(ids)

      expect(top_channels.ids).to eq ids
    end
  end
end
