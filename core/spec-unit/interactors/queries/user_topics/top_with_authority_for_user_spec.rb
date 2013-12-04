require 'pavlov_helper'
require_relative '../../../../app/entities/dead_user_topic'
require_relative '../../../../app/interactors/queries/user_topics/top_with_authority_for_user'

describe Queries::UserTopics::TopWithAuthorityForUser do
  include PavlovSupport

  before do
    stub_classes 'User', 'Channel'
  end

  describe '#call' do
    it 'some topic from the last couple of posted facts' do
      topic1 = double(slug_title: 'slug_title1', title: 'title1')
      topic2 = double(slug_title: 'slug_title2', title: 'title2')
      channel1 = double(id: 10, topic: topic1)
      channel2 = double(id: 20, topic: topic2)

      facts = [double(channels: double(ids: [channel1.id]))]
      sorted_created_facts = double(below: facts)
      graph_user = double(sorted_created_facts: sorted_created_facts)
      user = double(id: 'a1', graph_user: graph_user)

      query = described_class.new user_id: user.id, limit_topics: 1

      User.stub(:find).with(user.id).and_return(user)
      Channel.stub(:[]).with(channel1.id).and_return(channel1)
      Channel.stub(:[]).with(channel2.id).and_return(channel2)

      expect(query.call).to eq [DeadUserTopic.new(topic1.slug_title, topic1.title)]
    end

    it 'returns nothing if the latest fact has no channels' do
      facts = [double(channels: double(ids: []))]
      sorted_created_facts = double(below: facts)
      graph_user = double(sorted_created_facts: sorted_created_facts)
      user = double(id: 'a1', graph_user: graph_user)

      query = described_class.new user_id: user.id, limit_topics: 1

      User.stub(:find).with(user.id).and_return(user)

      expect(query.call).to eq []
    end

    it 'returns nothing if the user has no facts' do
      sorted_created_facts = double(below: [])
      graph_user = double(sorted_created_facts: sorted_created_facts)
      user = double(id: 'a1', graph_user: graph_user)

      query = described_class.new user_id: user.id, limit_topics: 1

      User.stub(:find).with(user.id).and_return(user)

      expect(query.call).to eq []
    end
  end
end
