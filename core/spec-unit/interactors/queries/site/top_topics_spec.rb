require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/site/top_topics'

describe Queries::Site::TopTopics do
  include PavlovSupport

  describe 'validations' do
    let(:subject_class) { Queries::Site::TopTopics }

    it 'requires site_id to be an integer' do
      expect_validating('', 2).
        to fail_validation('site_id should be an integer.')
    end

    it 'requires the number of items to return' do
      expect_validating(1, 'a').
        to fail_validation('nr should be an integer.')
    end
  end

  describe '.key' do
    it '.key returns the correct redis key' do
      site_id = 6
      redis_helper = mock

      command = Queries::Site::TopTopics.new site_id, 3
      command.should_receive(:redis).and_return( redis_helper )

      key = mock
      sub_key = mock

      redis_helper.should_receive(:[]).with(site_id).and_return(sub_key)
      sub_key.should_receive(:[]).with(:top_topics).and_return(key)

      expect(command.key).to eq key
    end
  end

  describe '.topic_slugs' do
    it 'returns an array of topic_slugs' do
      query = Queries::Site::TopTopics.new 1, 3

      result_list = mock

      key_mock = mock
      key_mock.should_receive(:zrevrange).with(0, 2).and_return(result_list)

      query.should_receive(:key).and_return(key_mock)

      expect(query.topic_slugs).to eq result_list
    end
  end

  describe '.execute' do

    before do
      stub_classes 'Topic'
      stub_classes 'KillObject'
    end


    it 'kills all the retrieved topics' do
      query = Queries::Site::TopTopics.new 1, 3

      topic1 = stub(id: '1e')
      topic2 = stub(id: '2f')

      dead_topic1 = mock
      dead_topic2 = mock

      query.stub topics: [topic1,topic2]

      KillObject.should_receive(:topic).with(topic1).and_return(dead_topic1)
      KillObject.should_receive(:topic).with(topic2).and_return(dead_topic2)

      expect(query.execute).to eq [dead_topic1, dead_topic2]
    end
  end

  describe '.topics' do
    it 'returns a list of Topics' do
      stub_classes 'Topic'
      query = Queries::Site::TopTopics.new 1, 3

      topics = [
        stub(slug_title: '1e'),
        stub(slug_title: '2f')
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
