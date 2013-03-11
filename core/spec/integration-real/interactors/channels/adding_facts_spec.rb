require 'spec_helper'

describe 'when adding a fact to a channel' do
  include Pavlov::Helpers

  let(:u1) { create :graph_user }
  let(:u2) { create :graph_user }
  let(:u3) { create :graph_user }

  let(:fact) {create :fact}

  let(:current_user) {create :user, graph_user: u1}

  def pavlov_options
    {current_user: current_user, ability: stub(:ability, can?: true)}
  end

  context 'with no followers' do
    before do
      @channel = Channel.create title: 'something', created_by: u1
      interactor :"channels/add_fact", fact, @channel
    end
    it "adds the fact to the channel" do
      facts = interactor :'channels/facts', @channel.id, nil, nil
      latest_fact = facts.map{|i| i[:item]}[0]
      expect(latest_fact).to eq fact
    end
    it "adds the fact to the channels topic" do
      Topic.for_channel(@channel)
      facts = interactor :'topics/facts', @channel.slug_title, nil, nil
    end
  end

  context 'with a follower' do
    before do
      @channel = Channel.create title: 'something', created_by: u1
      @sub_channel = Channel.create title: 'something2', created_by: u1

      @channel.add_channel @sub_channel

      interactor :"channels/add_fact", fact, @sub_channel
    end
    it "should add the fact to the follower" do
      facts = interactor :'channels/facts', @channel.id, nil, nil
      latest_fact = facts.map{|i| i[:item]}[0]
      expect(latest_fact).to eq fact
    end
  end

  context 'with a followed follower' do
    before do
      @channel = Channel.create title: 'something', created_by: u1
      @sub_channel = Channel.create title: 'something2', created_by: u1
      @sub_sub_channel = Channel.create title: 'something3', created_by: u1

      @channel.add_channel @sub_channel
      @sub_channel.add_channel @sub_sub_channel

      interactor :"channels/add_fact", fact, @sub_sub_channel
    end
    it "should add the fact to the indirect follower" do
      facts = interactor :'channels/facts', @channel.id, nil, nil
      expect(facts).to eq []
    end
  end
end
