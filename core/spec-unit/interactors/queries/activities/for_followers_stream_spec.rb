require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/activities/for_followers_stream'

describe Queries::Activities::ForFollowersStream do
  include PavlovSupport
  before do
    stub_classes 'GraphUser'
  end

  describe '#call' do
    it 'filters the activities using the Stream listener' do
      graph_user_id = 3
      activities = [double, nil, double, nil, double]
      graph_user = double :graph_user
      sorted_set = double :sorted_set
      query = described_class.new(graph_user_id: graph_user_id)

      allow(GraphUser)
        .to receive(:[])
        .with(graph_user_id)
        .and_return(graph_user)
      allow(graph_user)
        .to receive(:own_activities)
        .and_return(sorted_set)
      allow(sorted_set)
        .to receive(:below)
        .with('inf', count: 7, reversed: true, withscores: false)
        .and_return(activities)

      expect(query.call).to eq [activities[0], activities[2], activities[4]]
    end
  end
end
