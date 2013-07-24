require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/activities/for_followers_stream'

describe Queries::Activities::ForFollowersStream do
  include PavlovSupport
  before do
    stub_classes 'Activity', 'Activity::Listener::Stream'
  end

  describe '#call' do
    it 'filters the recent_activities using the Stream listener' do
      graph_user_id = 3
      activities = [mock, mock, mock]
      filtered_activities = [activities[0], activities[2]]
      listener = mock
      query = described_class.new(graph_user_id: graph_user_id)

      query.stub recent_activities: activities

      Activity::Listener::Stream.should_receive(:new)
                                .and_return(listener)

      listener.should_receive(:matches_any?)
              .with(activities[0])
              .and_return true
      listener.should_receive(:matches_any?)
              .with(activities[1])
              .and_return false
      listener.should_receive(:matches_any?)
              .with(activities[2])
              .and_return true

      expect(query.call).to eq filtered_activities
    end
  end

  describe '#recent_activities' do
    it 'returns recent activities this user created' do
      graph_user_id = 3
      activity_ids = mock
      activity_set = mock
      query = described_class.new(graph_user_id: graph_user_id)

      Activity.stub(:find)
              .with({user_id: graph_user_id})
              .and_return(activity_set)
      activity_set.stub(:sort)
                  .with(order: 'DESC', limit: 40)
                  .and_return(activity_ids)

      expect(query.recent_activities).to eq activity_ids
    end
  end
end
