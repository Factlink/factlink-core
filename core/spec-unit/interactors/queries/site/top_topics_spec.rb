require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/site/top_topics'

describe Queries::Site::TopTopics do
  include PavlovSupport

  describe 'validations' do
    let(:subject_class) { Queries::Site::TopTopics }

    it 'requires arguments' do
      expect_validating('').
        to fail_validation('site_id should be an integer.')
    end
  end

  describe '.key' do
    it '.key returns the correct redis key' do
      site_id = 6
      redis_helper = mock

      command = Queries::Site::TopTopics.new site_id
      command.should_receive(:redis).and_return( redis_helper )

      key = mock
      sub_key = mock

      redis_helper.should_receive(:[]).with(site_id).and_return(sub_key)
      sub_key.should_receive(:[]).with(:top_topics).and_return(key)

      expect(command.key).to eq key
    end
  end

  describe '.topic_ids' do
    it 'returns an array of topic_ids' do
      query = Queries::Site::TopTopics.new 1

      result_list = mock

      key_mock = mock
      key_mock.should_receive(:zrevrange).with(0, 2).and_return(result_list)

      query.should_receive(:key).and_return(key_mock)

      expect(query.topic_ids).to eq result_list
    end
  end

  describe '.execute' do

    before do
      stub_classes 'Topic'
      stub_classes 'KillObject'
    end

    it 'returns a list of Topics' do
      query = Queries::Site::TopTopics.new 1

      topic1 = stub(id: '1e')
      topic2 = stub(id: '2f')

      dead_topic1 = mock
      dead_topic2 = mock

      result_list = [topic1.id, topic2.id]

      Topic.should_receive(:find).with(topic1.id).and_return(topic1)
      Topic.should_receive(:find).with(topic2.id).and_return(topic2)

      KillObject.should_receive(:topic).with(topic1).and_return(dead_topic1)
      KillObject.should_receive(:topic).with(topic2).and_return(dead_topic2)

      query.should_receive(:topic_ids).and_return(result_list)
      expect(query.execute).to eq [dead_topic1, dead_topic2]
    end

  end
end
