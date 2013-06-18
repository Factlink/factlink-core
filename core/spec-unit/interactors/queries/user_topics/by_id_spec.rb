require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/user_topics/by_id'

describe Queries::UserTopics::ById do
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
      dead_topic = mock
      pavlov_options = {current_user: mock}

      query = described_class.new id, pavlov_options

      Topic.stub(:find).
        with(id).
        and_return(topic)

      query.stub(:query).
        with(:'user_topics/by_topic', topic).
        and_return(dead_topic)

      result = query.execute
      expect(result).to eq dead_topic
    end
  end
end
