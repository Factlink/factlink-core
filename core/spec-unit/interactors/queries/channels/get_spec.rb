require_relative '../../../../app/interactors/queries/channels/get'
require 'pavlov_helper'

describe Queries::Channels::Get do
  include PavlovSupport

  describe '.validate' do
    it 'requires id to be an integer' do
      expect_validating('a').
        to fail_validation('id should be an integer string.')
    end
  end

  describe '#call' do
    before do
      stub_classes 'Channel'
    end

    it 'correctly' do
      channel = mock id: '1'
      query = Queries::Channels::Get.new channel.id

      Channel.should_receive(:[]).with(channel.id)
             .and_return(channel)

      expect(query.execute).to eq channel
    end
    it "raises an exception when the channel is not found" do
      channel_id = '1'
      Channel.should_receive(:[]).with(channel_id).and_return(nil)
      expect do
        query = Queries::Channels::Get.new(channel_id)
        query.execute
      end.to raise_error(RuntimeError, "Channel #{channel_id} not found")
    end
  end
end
