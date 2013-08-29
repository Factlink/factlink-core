require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/channels/get'

describe Queries::Channels::Get do
  include PavlovSupport

  describe 'validations' do
    it 'requires id to be an integer' do
      expect_validating(id: 'a').
        to fail_validation('id should be an integer string.')
    end
  end

  describe '#call' do
    before do
      stub_classes 'Channel'
    end

    it 'correctly' do
      channel = double(id: '1')
      query = Queries::Channels::Get.new(id: channel.id)

      Channel.should_receive(:[]).with(channel.id)
             .and_return(channel)

      expect(query.call).to eq channel
    end

    it 'raises an exception when the channel is not found' do
      channel_id = '1'
      Channel.should_receive(:[]).with(channel_id).and_return(nil)
      expect do
        query = Queries::Channels::Get.new(id: channel_id)
        query.call
      end.to raise_error(RuntimeError, "Channel #{channel_id} not found")
    end
  end
end
