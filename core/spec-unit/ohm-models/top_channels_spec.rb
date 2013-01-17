require_relative '../../app/ohm-models/top_channels'

describe TopChannels do
  before do
    stub_const 'Channel', Class.new
  end

  describe '.add' do
    it 'adds a channel id to the list of handpicked channels' do
      id = 10
      handpicked_channels_interface = mock

      top_channels = TopChannels.new handpicked_channels_interface

      handpicked_channels_interface.should_receive(:sadd).with(id)

      top_channels.add(id)
    end
  end

  describe '.remove' do
    it 'adds a channel id to the list of handpicked channels' do
      id = 10
      handpicked_channels_interface = mock

      top_channels = TopChannels.new handpicked_channels_interface

      handpicked_channels_interface.should_receive(:srem).with(id)

      top_channels.remove(id)
    end
  end

  describe '.handpicked_channels_interface' do
    it 'returns a redis interface to the handpicked channels' do
      nest = mock
      interface = mock
      Nest.should_receive(:new).any_number_of_times.with(:top_channels).and_return nest
      nest.should_receive(:[]).any_number_of_times.with(:handpicked_channels).and_return(interface)

      top_channels = TopChannels.new

      expect(top_channels.handpicked_channels_interface).to eq interface
    end
  end

  describe '.members' do
    it "returns the actual channels" do
      channel = mock added_facts: (stub count: 1)
      nest = stub smembers: [14]
      Channel.should_receive(:[]).any_number_of_times.with(14).and_return channel

      top_channels = TopChannels.new nest

      expect(top_channels.members).to eq [channel]
    end
    it "doesn't return nil channels" do
      nest = stub smembers: [14]
      Channel.should_receive(:[]).any_number_of_times.with(14).and_return nil

      top_channels = TopChannels.new nest

      expect(top_channels.members).to eq []
    end
    it "doesn't return channels without added facts" do
      channel = stub added_facts: (stub count: 0)
      nest = stub smembers: [14]
      Channel.should_receive(:[]).any_number_of_times.with(14).and_return channel

      top_channels = TopChannels.new nest

      expect(top_channels.members).to eq []

    end
  end
end
