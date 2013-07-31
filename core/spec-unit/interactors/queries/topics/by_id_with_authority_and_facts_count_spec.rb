require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/topics/by_id_with_authority_and_facts_count'

describe Queries::Topics::ByIdWithAuthorityAndFactsCount do
  include PavlovSupport

  describe '#validate' do
    it 'calls the correct validation methods' do
      id = mock

      described_class.any_instance.should_receive(:validate_hexadecimal_string)
        .with(:id, id)

      interactor = described_class.new id
    end
  end

  describe '#call' do
    it 'returns the topic' do
      stub_classes 'Topic'

      id = '1a'
      topic = mock(slug_title: mock, title: mock)
      dead_topic = mock
      pavlov_options = {current_user: mock}


      Topic.stub(:find)
        .with(id)
        .and_return(topic)

      Pavlov.stub(:old_query)
        .with(:'topics/dead_topic_with_authority_and_facts_count_by_topic', topic, pavlov_options)
        .and_return(dead_topic)

      query = described_class.new id, pavlov_options

      expect(query.call).to eq dead_topic
    end
  end
end
