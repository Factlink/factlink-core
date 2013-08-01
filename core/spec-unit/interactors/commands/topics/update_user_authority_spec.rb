require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/topics/update_user_authority'

describe Commands::Topics::UpdateUserAuthority do
  include PavlovSupport

  before do
    stub_classes 'Authority', 'GraphUser', 'TopicsSortedByAuthority'
  end

  describe '#call' do
    let(:graph_user) { mock id: '12', user: mock(id: 'a87') }
    let(:topic) { mock id: 'a5', slug_title: 'foo' }
    let(:authority) { 15 }

    before do
      GraphUser.stub(:[]).once.with(graph_user.id)
               .and_return(graph_user)

      Pavlov.stub(:old_query).once
            .with(:'topics/by_slug_title', topic.slug_title)
            .and_return(topic)
    end

    it 'updates the authority' do
      authority_object = double

      query = described_class.new graph_user.id, topic.slug_title, authority


      Authority.stub(:from).with(topic, for: graph_user)
               .and_return authority_object
      topic.stub(top_users_add: nil)
      TopicsSortedByAuthority.stub new: (mock set:nil)

      authority_object.should_receive(:<<)
                      .with(authority)

      query.call
    end

    it "updates the top_users of the topic" do
      authority_object = double

      query = described_class.new graph_user.id, topic.slug_title, authority

      Authority.stub from: mock(:<< => nil)
      TopicsSortedByAuthority.stub new: (mock set:nil)

      topic.should_receive(:top_users_add)
           .with(graph_user.user, authority)

      query.call
    end

    it "updates the top topics of the user" do
      user_topics_list = double

      query = described_class.new graph_user.id, topic.slug_title, authority

      Authority.stub from: mock(:<< => nil)
      topic.stub(top_users_add: nil)

      TopicsSortedByAuthority.stub(:new)
                           .with(graph_user.user.id)
                           .and_return(user_topics_list)

      user_topics_list.should_receive(:set)
                      .with(topic.id, authority)

      query.call
    end
  end

end
