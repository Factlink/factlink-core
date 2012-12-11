require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/site/add_top_topic.rb'

describe Commands::Site::AddTopTopic do
  include PavlovSupport

  describe '.new' do
    it 'should initialize correctly' do
      command = Commands::Site::AddTopTopic.new 1, "2e"
      expect(command).not_to be_nil
    end
  end

  describe 'validations' do
    let(:subject_class) { Commands::Site::AddTopTopic }
    it 'requires arguments' do
      expect_validating(1, 1).
        to fail_validation('topic_slug should be a string.')
    end

    it 'requires arguments' do
      expect_validating('', '11ee').
        to fail_validation('site_id should be an integer.')
    end
  end

  describe '.execute' do

    it '.key returns the correct redis key' do
      site_id = 6
      topic_slug = '12ab34cd'
      redis_helper = mock

      command = Commands::Site::AddTopTopic.new site_id, topic_slug
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

      command = Commands::Site::AddTopTopic.new site_id, topic_slug

      key_mock = mock()
      key_mock.should_receive(:zincrby).with(1, topic_slug)
      command.stub key: key_mock

      command.execute
    end
  end

end
