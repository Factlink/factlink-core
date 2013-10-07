require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/topics/by_id_with_statistics'

describe Queries::Topics::ByIdWithStatistics do
  include PavlovSupport

  describe '#call' do
    it 'calls the correct validation methods' do
      expect_validating(id: 'not a hex string')
        .to fail_validation 'id should be an hexadecimal string.'
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

      Pavlov.stub(:query)
            .with(:'topics/dead_topic_with_statistics_by_topic',
                      alive_topic: topic, pavlov_options: pavlov_options)
            .and_return(dead_topic)

      expect(query.call).to eq dead_topic
    end
  end
end
