require 'pavlov_helper'
require_relative '../../../../app/entities/dead_user_topic'
require_relative '../../../../app/interactors/queries/user_topics/last_used_for_user'

describe Queries::UserTopics::LastUsedForUser do
  include PavlovSupport

  before do
    stub_classes 'User'
  end

  describe '#call' do
    it 'some topic from the last couple of posted facts' do
      topic = double(slug_title: 'slug_title', title: 'title')
      channel = double(topic: topic)
      facts = [double(channels: [channel])]
      sorted_created_facts = double(below: facts)
      graph_user = double(sorted_created_facts: sorted_created_facts)
      user = double(id: 'a1', graph_user: graph_user)

      query = described_class.new user_id: user.id

      User.stub(:find).with(user.id).and_return(user)

      expect(query.call).to eq [DeadUserTopic.new(topic.slug_title, topic.title)]
    end

    it 'returns nothing if the latest fact has no channels' do
      facts = [double(channels: [])]
      sorted_created_facts = double(below: facts)
      graph_user = double(sorted_created_facts: sorted_created_facts)
      user = double(id: 'a1', graph_user: graph_user)

      query = described_class.new user_id: user.id

      User.stub(:find).with(user.id).and_return(user)

      expect(query.call).to eq []
    end

    it 'returns nothing if the user has no facts' do
      sorted_created_facts = double(below: [])
      graph_user = double(sorted_created_facts: sorted_created_facts)
      user = double(id: 'a1', graph_user: graph_user)

      query = described_class.new user_id: user.id

      User.stub(:find).with(user.id).and_return(user)

      expect(query.call).to eq []
    end
  end
end
