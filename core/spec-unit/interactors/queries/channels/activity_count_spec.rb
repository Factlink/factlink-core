require_relative '../../../../app/interactors/queries/channels/activity_count'
require 'pavlov_helper'

describe Queries::Channels::ActivityCount do
  include PavlovSupport

  describe '.execute' do
    it 'correctly' do
      channel_klass = mock
      channel = mock
      stub_const('Channel',channel_klass)
      activities = mock
      timestamp = mock
      channel_id = mock
      query = Queries::Channels::ActivityCount.new channel_id, timestamp

      Channel.should_receive(:[]).with(channel_id).and_return(channel)
      channel.should_receive(:activities).and_return(activities)
      activities.should_receive(:count_above).with(timestamp)

      query.execute
    end
  end
end
