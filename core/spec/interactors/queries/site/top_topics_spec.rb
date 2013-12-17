require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/site/top_topics'

describe Queries::Site::TopTopics do
  include PavlovSupport

  before do
    stub_classes 'Topic'
  end

  describe '#key' do
    it '.key returns the correct redis key' do
      site_id = 6
      query = described_class.new site_id: site_id, nr: 3

      expect(query.key).to eq  "site:#{site_id}:top_topics"
    end
  end

  describe '#topic_slugs' do
    it 'returns an array of topic_slugs' do
      query = described_class.new site_id: 1, nr: 3
      result_list = double
      key_double = double

      key_double.should_receive(:zrevrange).with(0, 2).and_return(result_list)
      query.should_receive(:key).and_return(key_double)

      expect(query.topic_slugs).to eq result_list
    end
  end

  describe '#call' do
    it 'kills all the retrieved topics' do
      query = described_class.new site_id: 1, nr: 3
      topics = [
        double(id: '1e', title: 'Foo', slug_title: 'foo', save: nil),
        double(id: '2f', title: 'Bar', slug_title: 'bar', save: nil)
      ]

      query.stub topics: topics

      results = query.call

      expect(results[0]).to_not respond_to(:save)
      expect(results[0].title).to eq topics[0].title
      expect(results[1]).to_not respond_to(:save)
      expect(results[1].title).to eq topics[1].title
    end
  end

  describe '.topics' do
    it 'returns a list of Topics' do
      stub_classes 'Topic'
      query = described_class.new site_id: 1, nr: 3
      topics = [        double(slug_title: '1e'),        double(slug_title: '2f')
      ]
      topic_slugs = topics.map(&:slug_title)

      topics.each do |topic|
        Topic.should_receive(:where).with(slug_title: topic.slug_title).and_return([topic])
      end
      query.should_receive(:topic_slugs).and_return(topic_slugs)

      expect(query.topics).to match_array topics
    end
  end
end
