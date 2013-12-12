require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/topics/favourite_topic_ids'

describe Queries::Topics::FavouriteTopicIds do
  include PavlovSupport

  before do
    stub_classes 'UserFavouritedTopics'
  end

  describe '#call' do
    it 'returns the ids of follower' do
      graph_user_id = double
      ids = double
      users_favourited_topics = double
      query = described_class.new graph_user_id: graph_user_id

      UserFavouritedTopics.should_receive(:new).with(graph_user_id).and_return(users_favourited_topics)
      users_favourited_topics.should_receive(:topic_ids).and_return(ids)

      result = query.call

      expect(result).to eq ids
    end
  end
end
