require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/topics/favourite_topic_ids'

describe Queries::Topics::FavouriteTopicIds do
  include PavlovSupport

  describe '#execute' do
    before do
      described_class.any_instance.stub(validate: true)

      stub_classes 'UserFavouritedTopics'
    end

    it 'returns the ids of follower' do
      graph_user_id = mock
      ids = mock
      users_favourited_topics = mock

      UserFavouritedTopics.should_receive(:new).with(graph_user_id).and_return(users_favourited_topics)
      users_favourited_topics.should_receive(:topic_ids).and_return(ids)

      query = described_class.new graph_user_id
      result = query.execute

      expect(result).to eq ids
    end
  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      graph_user_id = mock

      described_class.any_instance.should_receive(:validate_integer_string).with(:graph_user_id, graph_user_id)

      query = described_class.new graph_user_id
    end
  end
end
