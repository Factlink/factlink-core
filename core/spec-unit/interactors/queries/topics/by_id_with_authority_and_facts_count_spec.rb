require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/topics/by_id_with_authority_and_facts_count'

describe Queries::Topics::ByIdWithAuthorityAndFactsCount do
  include PavlovSupport

  describe '#call' do
    it 'calls the correct validation methods' do
      query = described_class.new id: 'not a hex string'

      expect{ query.call }.to raise_error(Pavlov::ValidationError,
        'id should be an hexadecimal string.')
    end

    it 'returns the topic' do
      stub_classes 'Topic'
      id = '1a'
      topic = double(slug_title: double, title: double)
      dead_topic = double
      pavlov_options = {current_user: double}
      query = described_class.new id: id, pavlov_options: pavlov_options

      Topic.stub(:find)
        .with(id)
        .and_return(topic)

      Pavlov.stub(:old_query)
        .with(:'topics/dead_topic_with_authority_and_facts_count_by_topic', topic, pavlov_options)
        .and_return(dead_topic)

      expect(query.call).to eq dead_topic
    end
  end
end
