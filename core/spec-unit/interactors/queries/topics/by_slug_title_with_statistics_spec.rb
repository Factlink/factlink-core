require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/topics/by_slug_title_with_statistics'

describe Queries::Topics::BySlugTitleWithStatistics do
  include PavlovSupport

  describe 'validation' do
    it 'checks the slug_title' do
      expect_validating(slug_title: 1)
        .to fail_validation 'slug_title should be a string.'
    end
  end
  describe '#call' do
    it 'returns the topic' do
      topic = double(slug_title: 'slug_title', title: double)
      dead_topic = double
      pavlov_options = {current_user: double}
      query = described_class.new slug_title: topic.slug_title, pavlov_options: pavlov_options

      Pavlov.stub(:query)
        .with(:'topics/by_slug_title', slug_title: topic.slug_title, pavlov_options: pavlov_options)
        .and_return(topic)
      Pavlov.stub(:query)
        .with(:'topics/dead_topic_with_statistics_by_topic', alive_topic: topic, pavlov_options: pavlov_options)
        .and_return(dead_topic)

      expect(query.call).to eq dead_topic
    end
  end
end
