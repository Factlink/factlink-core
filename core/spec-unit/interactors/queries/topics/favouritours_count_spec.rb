require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/topics/favouritours_count'

describe Queries::Topics::FavouritoursCount do
  include PavlovSupport

  before do
    stub_classes 'TopicsFavouritedByUsers'
  end

  describe '#execute' do
    it 'returns the number of followers' do
      topic_id = '1a'
      count = double
      topics_favourited_by_users = double(favouritours_count: count)
      query = described_class.new topic_id: topic_id

      TopicsFavouritedByUsers.stub(:new).with(topic_id)
        .and_return(topics_favourited_by_users)

      expect(query.execute).to eq count
    end
  end
end
