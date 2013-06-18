require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/user_topics/by_id'

describe Queries::DeadUserTopics::ById do
  include PavlovSupport

  describe '#validate' do
    before do
      described_class.any_instance.stub(authorized?: true)
    end

    it 'calls the correct validation methods' do
      id = mock

      described_class.any_instance.should_receive(:validate_hexadecimal_string).
        with(:id, id)

      interactor = described_class.new id
    end
  end

  describe '#execute' do
    before do
      described_class.any_instance.stub(validate: true)
    end

    it 'returns the topic Topic.find' do
      stub_classes 'Topic', 'DeadUserTopic'

      id = mock
      topic = mock(slug_title: mock, title: mock)
      facts_count = mock
      current_user_authority = mock
      current_user = mock(graph_user: mock)
      dead_topic = mock

      query = described_class.new id, current_user: current_user

      Topic.stub(:find).
        with(id).
        and_return(topic)

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
