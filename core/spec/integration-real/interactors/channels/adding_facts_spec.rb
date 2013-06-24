require 'spec_helper'

describe 'when adding a fact to a channel' do
  include PavlovSupport

  context 'with no followers' do
    let(:user) {create :user}
    it "adds the fact to the channel" do
      as(user) do |pavlov|
        fact = pavlov.interactor :'facts/create', 'a fact', '', '', {}

        channel = pavlov.command :'channels/create', 'something'
        pavlov.interactor :"channels/add_fact", fact, channel

        facts = pavlov.interactor :'channels/facts', channel.id, nil, nil
        latest_fact = facts.map{|i| i[:item]}[0]
        expect(latest_fact).to eq fact
      end
    end

    it "adds the fact to the channels topic" do
      as(user) do |pavlov|
        fact = pavlov.interactor :'facts/create', 'a fact', '', '', {}

        channel = pavlov.command :'channels/create', 'something'
        pavlov.interactor :"channels/add_fact", fact, channel

        Topic.for_channel(channel)
        facts = pavlov.interactor :'topics/facts', channel.slug_title, nil, nil
        fact_displaystrings = facts.map {|f| f[:item].data.displaystring}

        expect(fact_displaystrings).to eq ['a fact']
      end
    end
  end

  context 'with a follower' do
    let(:follower) {create :user}
    let(:creator) {create :user}

    it "should add the fact to the follower" do
      fact, sub_channel, channel = ()

      as(creator) do |pavlov|
        sub_channel = pavlov.command :'channels/create', 'something'
        fact = pavlov.interactor :'facts/create', 'a fact', '', '', {}
      end

      as(follower) do |pavlov|
        channel = pavlov.command :'channels/create', 'something2'
        pavlov.interactor :"channels/add_subchannel", channel.id, sub_channel.id
      end

      as(creator) do |pavlov|
        pavlov.interactor :"channels/add_fact", fact, sub_channel
      end

      as(follower) do |pavlov|
        facts = pavlov.interactor :'channels/facts', channel.id, nil, nil
        latest_fact = facts.map{|i| i[:item]}[0]
        expect(latest_fact).to eq fact
      end
    end
  end

  context 'with a followed follower' do
    let(:follower) {create :user}
    let(:followers_follower) {create :user}
    let(:creator) {create :user}

    it "should add the fact to the follower" do
      fact, sub_sub_channel, sub_channel, channel = ()

      as(creator) do |pavlov|
        sub_sub_channel = pavlov.command :'channels/create', 'something'
        fact = pavlov.interactor :'facts/create', 'a fact', '', '', {}
      end

      as(follower) do |pavlov|
        sub_channel = pavlov.command :'channels/create', 'something2'
        pavlov.interactor :"channels/add_subchannel", sub_channel.id, sub_sub_channel.id
      end

      as(followers_follower) do |pavlov|
        channel = pavlov.command :'channels/create', 'something2'
        pavlov.interactor :"channels/add_subchannel", channel.id, sub_channel.id
      end

      as(creator) do |pavlov|
        pavlov.interactor :"channels/add_fact", fact, sub_sub_channel
      end

      as(followers_follower) do |pavlov|
        facts = pavlov.interactor :'channels/facts', channel.id, nil, nil
        expect(facts).to eq []
      end
    end
  end
end
