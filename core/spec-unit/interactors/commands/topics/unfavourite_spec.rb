require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/topics/unfavourite'

describe Commands::Topics::Unfavourite do
  include PavlovSupport

  describe '#execute' do
    before do
      described_class.any_instance.stub validate: true
      stub_classes 'UserFavouritedTopics'
    end

    it 'calls UserFavouritedTopics.unfavourite to unfavourite the topic' do
      graph_user_id = double
      topic_id = double
      users_favourited_topics = double

      UserFavouritedTopics.stub(:new)
                        .with(graph_user_id)
                        .and_return(users_favourited_topics)

      users_favourited_topics.should_receive(:unfavourite)
                           .with(topic_id)

      query = described_class.new graph_user_id: graph_user_id,
        topic_id: topic_id

      query.execute
    end
  end

  describe 'validation' do
    it 'requires a graph_user_id' do
      expect_validating(graph_user_id: '', topic_id: '1a')
        .to fail_validation('graph_user_id should be an integer string.')
    end

    it 'requires a topic_id' do
      expect_validating(graph_user_id: '6', topic_id: '')
        .to fail_validation('topic_id should be an hexadecimal string.')
    end
  end
end
