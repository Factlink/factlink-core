require 'spec_helper'

describe TopChannels do
  describe '.add' do
    it 'should add some channel ids' do
      id1 = "10"
      id2 = "20"
      id3 = "30"
      ids = [id1, id2, id3]

      top_channels_instance = TopChannels.new
      top_channels_instance.add id1
      top_channels_instance.add id2
      top_channels_instance.add id3

      expect(top_channels_instance.ids).to eq ids
    end
  end
end
