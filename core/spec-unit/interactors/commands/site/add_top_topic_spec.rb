require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/site/add_top_topic.rb'

describe Commands::Site::AddTopTopic do
  include PavlovSupport

  describe 'validations' do
    it 'requires topic_slug' do
      expect_validating(topic_slug: 15, site_id: 1)
        .to fail_validation('topic_slug should be a string.')
    end

    it 'requires site_id' do
      expect_validating(topic_slug: '', site_id: '11ee')
        .to fail_validation('site_id should be an integer.')
    end
  end

  describe '#call' do
    it '.key returns the correct redis key' do
      site_id = 6
      topic_slug = '12ab34cd'
      redis_helper = mock

      command = described_class.new site_id: site_id, topic_slug: topic_slug
      command.should_receive(:redis).and_return( redis_helper )

      key = mock
      sub_key = mock

      redis_helper.should_receive(:[]).with(site_id).and_return(sub_key)
      sub_key.should_receive(:[]).with(:top_topics).and_return(key)

      expect(command.key).to eq key
    end

    it 'adds the topic to the top topics of the site' do
      site_id = 6
      topic_slug = '12ab34cd'

      command = described_class.new site_id: site_id, topic_slug: topic_slug

      key_mock = mock()
      key_mock.should_receive(:zincrby).with(1, topic_slug)
      command.stub key: key_mock

      command.call
    end
  end
end
