require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/topics/dead_topic_with_authority_and_facts_count_by_topic'

describe Queries::Topics::DeadTopicWithAuthorityAndFactsCountByTopic do
  include PavlovSupport

  describe '#validate' do
    it 'calls the correct validation methods' do
      topic = mock

      described_class.any_instance.should_receive(:validate_not_nil)
        .with(:alive_topic, topic)

      interactor = described_class.new topic
    end
  end

  describe '#execute' do
    it 'returns the topic' do
      stub_classes 'DeadTopic'

      topic = mock(slug_title: mock, title: mock)
      facts_count = mock
      current_user_authority = mock
      current_user = mock(graph_user: mock)
      dead_topic = mock
      pavlov_options = {current_user: current_user}

      Pavlov.stub(:old_query)
        .with(:'topics/facts_count', topic.slug_title, pavlov_options)
        .and_return(facts_count)

      Pavlov.stub(:old_query)
        .with(:authority_on_topic_for, topic, current_user.graph_user, pavlov_options)
        .and_return(current_user_authority)

      DeadTopic.stub(:new)
        .with(topic.slug_title, topic.title, current_user_authority, facts_count)
        .and_return(dead_topic)

      query = described_class.new topic, pavlov_options

      expect(query.call).to eq dead_topic
    end
  end
end
