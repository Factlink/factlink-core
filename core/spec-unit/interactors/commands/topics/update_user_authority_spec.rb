require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/topics/update_user_authority'

describe Commands::Topics::UpdateUserAuthority do
  include PavlovSupport

  before do
    stub_classes 'Authority', 'GraphUser', 'TopicsSortedByAuthority'
  end

  describe '#call' do
    let(:graph_user) { double id: '12', user: double(id: 'a87') }
    let(:topic) { double id: 'a5', slug_title: 'foo' }
    let(:authority) { 15 }

    before do
      GraphUser.stub(:[]).once.with(graph_user.id)
               .and_return(graph_user)

      Pavlov.stub(:query).once
            .with(:'topics/by_slug_title', slug_title: topic.slug_title)
            .and_return(topic)
    end

    it 'updates the authority' do
      authority_object = double

      command = described_class.new graph_user_id: graph_user.id,
        topic_slug: topic.slug_title, authority: authority


      Authority.stub(:from).with(topic, for: graph_user)
               .and_return authority_object
      topic.stub(top_users_add: nil)
      TopicsSortedByAuthority.stub new: (double set:nil)

      authority_object.should_receive(:<<)
                      .with(authority)

      command.call
    end

    it "updates the top_users of the topic" do
      authority_object = double

      command = described_class.new graph_user_id: graph_user.id,
        topic_slug: topic.slug_title, authority: authority

      Authority.stub from: double(:<< => nil)
      TopicsSortedByAuthority.stub new: (double set:nil)

      topic.should_receive(:top_users_add)
           .with(graph_user.user, authority)

      command.call
    end

    it "updates the top topics of the user" do
      user_topics_list = double

      command = described_class.new graph_user_id: graph_user.id,
        topic_slug: topic.slug_title, authority: authority

      Authority.stub from: double(:<< => nil)
      topic.stub(top_users_add: nil)

      TopicsSortedByAuthority.stub(:new)
                           .with(graph_user.user.id)
                           .and_return(user_topics_list)

      user_topics_list.should_receive(:set)
                      .with(topic.id, authority)

      command.call
    end
  end

  describe 'validation' do
    it 'requires a graph_user_id' do
      expect_validating(graph_user_id: '', topic_slug: '1a', authority: double)
        .to fail_validation('graph_user_id should be an integer string.')
    end

    it 'requires a topic_slug' do
      expect_validating(graph_user_id: '6', topic_slug: 34, authority: double)
        .to fail_validation('topic_slug should be a string.')
    end
  end

end
