require_relative '../../../../app/interactors/queries/channels/get'
require 'pavlov_helper'

describe Queries::Channels::Get do
  include PavlovSupport

  it '.new' do
    interactor = Queries::Channels::Get.new '1'
    interactor.should_not be_nil
  end

  describe '.validate' do
    let(:subject_class) { Queries::Channels::Get }

    it 'requires id to be an integer' do
      expect_validating('a', :id).
        to fail_validation('id should be an integer string.')
    end
  end

  describe '.execute' do
    before do
      stub_const('Channel', Class.new)
    end

    it 'correctly' do
      channel = mock
      channel_id = '1'
      query = Queries::Channels::Get.new channel_id

      Channel.should_receive(:[]).with(channel_id).and_return(channel)

      query.execute.should eq channel
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
