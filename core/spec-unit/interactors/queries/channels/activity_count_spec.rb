require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/channels/activity_count'

describe Queries::Channels::ActivityCount do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'Channel'
    end

    it 'correctly' do
      activities = double
      channel = double activities: activities
      timestamp = double
      channel_id = double
      count = double
      query = described_class.new(channel_id: channel_id, timestamp: timestamp)

      Channel.stub(:[]).with(channel_id).and_return(channel)
      activities.stub(:count_above).with(timestamp).and_return(count)

      expect(query.call).to eq count
    end
  end
end
