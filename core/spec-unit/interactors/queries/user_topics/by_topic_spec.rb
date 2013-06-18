require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/user_topics/by_topic'

describe Queries::UserTopics::ByTopic do
  include PavlovSupport

  describe '#validate' do
    it 'calls the correct validation methods' do
      topic = mock

      described_class.any_instance.should_receive(:validate_not_nil).
        with(:alive_topic, topic)

      interactor = described_class.new topic
    end
  end

  describe '#execute' do
    before do
      described_class.any_instance.stub(validate: true)
    end

    it 'returns the user topic' do
      stub_classes 'DeadUserTopic'

      topic = mock(slug_title: mock, title: mock)
      facts_count = mock
      current_user_authority = mock
      current_user = mock(graph_user: mock)
      dead_topic = mock

      query = described_class.new topic, current_user: current_user

      query.stub(:query).
        with(:'topics/facts_count', topic.slug_title).
        and_return(facts_count)

      query.stub(:query).
        with(:authority_on_topic_for, topic, current_user.graph_user).
        and_return(current_user_authority)

      DeadUserTopic.stub(:new).
        with(topic.slug_title, topic.title, current_user_authority, facts_count).
        and_return(dead_topic)

      result = query.execute
      expect(result).to eq dead_topic
    end
  end
end
