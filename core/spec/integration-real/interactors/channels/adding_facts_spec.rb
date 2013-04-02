require 'spec_helper'

describe 'when adding a fact to a channel' do
  include PavlovSupport
  let(:current_user) {create :user}

  context 'with no followers' do
    it "adds the fact to the channel" do
      fact = create :fact

      as(current_user) do |pavlov|
        channel = pavlov.command :'channels/create', 'something'
        pavlov.interactor :"channels/add_fact", fact, channel

        facts = pavlov.interactor :'channels/facts', channel.id, nil, nil
        latest_fact = facts.map{|i| i[:item]}[0]
        expect(latest_fact).to eq fact
      end
    end

    it "adds the fact to the channels topic" do
      fact = create :fact

      as(current_user) do |pavlov|
        channel = pavlov.command :'channels/create', 'something'
        pavlov.interactor :"channels/add_fact", fact, channel

        Topic.for_channel(channel)
        facts = pavlov.interactor :'topics/facts', channel.slug_title, nil, nil
      end
    end
  end

  context 'with a follower' do
    it "should add the fact to the follower" do
      fact = create :fact

      as(current_user) do |pavlov|
        channel = pavlov.command :'channels/create', 'something'
        sub_channel = pavlov.command :'channels/create', 'something2'

        pavlov.command :"channels/add_subchannel", channel, sub_channel
        pavlov.interactor :"channels/add_fact", fact, sub_channel

        facts = pavlov.interactor :'channels/facts', channel.id, nil, nil
        latest_fact = facts.map{|i| i[:item]}[0]
        expect(latest_fact).to eq fact
      end
    end
  end

  context 'with a followed follower' do
    it "should not add the fact to the indirect follower" do
      fact = create :fact

      as(current_user) do |pavlov|

        channel = pavlov.command :'channels/create', 'something'
        sub_channel = pavlov.command :'channels/create', 'something2'
        sub_sub_channel = pavlov.command :'channels/create', 'something3'

        pavlov.command :"channels/add_subchannel", channel, sub_channel
        pavlov.command :"channels/add_subchannel", sub_channel, sub_sub_channel

        pavlov.interactor :"channels/add_fact", fact, sub_sub_channel

        facts = pavlov.interactor :'channels/facts', channel.id, nil, nil
        expect(facts).to eq []
      end
    end
  end
end
