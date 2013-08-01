require_relative '../../../../app/interactors/queries/channels/activity_count'
require 'pavlov_helper'

describe Queries::Channels::ActivityCount do
  include PavlovSupport

  describe '#call' do
    before do
      stub_const('Channel', Class.new)
    end

    it 'correctly' do
      channel = double
      activities = double
      timestamp = double
      channel_id = double
      count = double
      query = described_class.new(channel_id: channel_id, timestamp: timestamp)

      Channel.should_receive(:[]).with(channel_id).and_return(channel)
      channel.should_receive(:activities).and_return(activities)
      activities.should_receive(:count_above).with(timestamp).and_return(count)

      expect( query.call ).to eq count
    end
  end
end
