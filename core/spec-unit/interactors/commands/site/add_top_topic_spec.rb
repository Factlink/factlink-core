require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/site/add_top_topic.rb'

describe Commands::Site::AddTopTopic do
  include PavlovSupport

  describe '#call' do
    it '.key returns the correct redis key' do
      site_id = 6
      topic_slug = '12ab34cd'
      redis_helper = double

      command = described_class.new site_id: site_id, topic_slug: topic_slug
      command.should_receive(:redis).and_return( redis_helper )

      key = double
      sub_key = double

      redis_helper.should_receive(:[]).with(site_id).and_return(sub_key)
      sub_key.should_receive(:[]).with(:top_topics).and_return(key)

      expect(command.key).to eq key
    end

    it 'adds the topic to the top topics of the site' do
      site_id = 6
      topic_slug = '12ab34cd'

      command = described_class.new site_id: site_id, topic_slug: topic_slug

      key_double = double
      key_double.should_receive(:zincrby).with(1, topic_slug)
      command.stub key: key_double

      command.call
    end
  end
end
