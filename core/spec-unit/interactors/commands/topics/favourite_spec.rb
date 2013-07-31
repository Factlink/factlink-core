require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/topics/favourite'

describe Commands::Topics::Favourite do
  include PavlovSupport

  describe '#execute' do
    before do
      described_class.any_instance.stub validate: true
      stub_classes 'UserFavouritedTopics'
    end

    it 'calls UserFavouritedTopics.favourite to favourite the topic' do
      graph_user_id = double
      topic_id = double
      users_favourited_topics = double

      UserFavouritedTopics.stub(:new)
                        .with(graph_user_id)
                        .and_return(users_favourited_topics)

      users_favourited_topics.should_receive(:favourite)
                           .with(topic_id)

      query = described_class.new graph_user_id, topic_id

      query.execute
    end
  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      graph_user_id = double
      topic_id = double

      described_class.any_instance.should_receive(:validate_integer_string)
                                  .with(:graph_user_id, graph_user_id)
      described_class.any_instance.should_receive(:validate_hexadecimal_string)
                                  .with(:topic_id, topic_id)

      query = described_class.new graph_user_id, topic_id
    end
  end
end
