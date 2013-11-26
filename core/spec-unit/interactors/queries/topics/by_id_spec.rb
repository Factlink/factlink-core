require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/topics/by_id'

describe Queries::Topics::ById do
  include PavlovSupport

  before do
    stub_classes 'Topic'
  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      expect_validating(id: 'this is not hexadecimal')
        .to fail_validation 'id should be an hexadecimal string.'
    end
  end

  describe '#call' do
    it 'returns the topic Topic.find' do
      id = '1a'
      topic = double save: nil, title: 'Foo', slug_title: 'foo'
      dead_topic = double
      query = described_class.new id: id

      allow(Topic).to receive(:find)
        .with(id)
        .and_return(topic)

      result = query.call

      expect(result).to_not respond_to(:save)
      expect(result.title).to eq topic.title
    end
  end
end
