require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/topics/favourite_topic_ids'

describe Queries::Topics::FavouriteTopicIds do
  include PavlovSupport

  before do
    stub_classes 'UserFavouritedTopics'
  end

  describe '#call' do
    before do
      described_class.any_instance.stub(validate: true)
    end

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

  describe '#validate' do
    it 'calls the correct validation methods' do
      graph_user_id = double
      query = described_class.new graph_user_id: graph_user_id
      UserFavouritedTopics.stub(new: double(topic_ids: double))

      query.should_receive(:validate_integer_string)
        .with(:graph_user_id, graph_user_id)

      query.call
    end
  end
end
