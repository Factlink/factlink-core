require 'spec_helper'

describe 'when adding a fact to a channel' do
  include PavlovSupport

  context 'with no followers' do
    let(:user) { create :active_user }
    it "adds the fact to the channel" do
      as(user) do |pavlov|
        fact = pavlov.interactor :'facts/create', displaystring: 'a fact', url: '', title: '', sharing_options: {}

        channel = pavlov.command :'channels/create', title: 'something'
        pavlov.interactor :'channels/add_fact', fact: fact, channel: channel

        facts = pavlov.interactor :'channels/facts', id: channel.id, from: nil, count: nil
        latest_fact = facts.map{|i| i[:item]}[0]
        expect(latest_fact).to eq fact
      end
    end

    it "adds the fact to the channels topic" do
      as(user) do |pavlov|
        fact = pavlov.interactor :'facts/create', displaystring: 'a fact', url: '', title: '', sharing_options: {}

        channel = pavlov.command :'channels/create', title: 'something'
        pavlov.interactor :'channels/add_fact', fact: fact, channel: channel

        Topic.get_or_create_by_channel(channel)
        facts = pavlov.interactor :'topics/facts', slug_title: channel.slug_title, count: nil, max_timestamp: nil
        fact_displaystrings = facts.map {|f| f[:item].data.displaystring}

        expect(fact_displaystrings).to eq ['a fact']
      end
    end
  end

  context 'with a follower' do
    let(:follower) { create :active_user }
    let(:creator) { create :active_user }

    it "should add the fact to the follower" do
      fact, sub_channel, channel = ()

      as(creator) do |pavlov|
        sub_channel = pavlov.command :'channels/create', title: 'something'
        fact = pavlov.interactor :'facts/create', displaystring: 'a fact', url: '', title: '', sharing_options: {}
      end

      as(follower) do |pavlov|
        channel = pavlov.command :'channels/create', title: 'something2'
        pavlov.interactor :'channels/add_subchannel', channel_id: channel.id, subchannel_id: sub_channel.id
      end

      as(creator) do |pavlov|
        pavlov.interactor :'channels/add_fact', fact: fact, channel: sub_channel
      end

      as(follower) do |pavlov|
        facts = pavlov.interactor :'channels/facts', id: channel.id, from: nil, count: nil
        latest_fact = facts.map{|i| i[:item]}[0]
        expect(latest_fact).to eq fact
      end
    end
  end

  context 'with a followed follower' do
    let(:follower) { create :active_user }
    let(:followers_follower) { create :active_user }
    let(:creator) { create :active_user }

    it "should add the fact to the follower" do
      fact, sub_sub_channel, sub_channel, channel = ()

      as(creator) do |pavlov|
        sub_sub_channel = pavlov.command :'channels/create', title: 'something'
        fact = pavlov.interactor :'facts/create', displaystring: 'a fact', url: '', title: '', sharing_options: {}
      end

      as(follower) do |pavlov|
        sub_channel = pavlov.command :'channels/create', title: 'something2'
        pavlov.interactor :'channels/add_subchannel', channel_id: sub_channel.id, subchannel_id: sub_sub_channel.id
      end

      as(followers_follower) do |pavlov|
        channel = pavlov.command :'channels/create', title: 'something2'
        pavlov.interactor :'channels/add_subchannel', channel_id: channel.id, subchannel_id: sub_channel.id
      end

      as(creator) do |pavlov|
        pavlov.interactor :'channels/add_fact', fact: fact, channel: sub_sub_channel
      end

      as(followers_follower) do |pavlov|
        facts = pavlov.interactor :'channels/facts', id: channel.id, from: nil, count: nil
        expect(facts).to eq []
      end
    end
  end
end
