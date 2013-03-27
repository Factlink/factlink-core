require 'spec_helper'

describe 'when adding a fact to a channel' do
  include Pavlov::Helpers

  let(:fact) {create :fact}

  def pavlov_options
    {current_user: (create :user), ability: stub(:ability, can?: true)}
  end

  context 'with no followers' do
    it "adds the fact to the channel" do
      channel = command :'channels/create', 'something'
      interactor :"channels/add_fact", fact, channel

      facts = interactor :'channels/facts', channel.id, nil, nil
      latest_fact = facts.map{|i| i[:item]}[0]
      expect(latest_fact).to eq fact
    end

    it "adds the fact to the channels topic" do
      channel = command :'channels/create', 'something'
      interactor :"channels/add_fact", fact, channel

      Topic.for_channel(channel)
      facts = interactor :'topics/facts', channel.slug_title, nil, nil
    end
  end

  context 'with a follower' do
    it "should add the fact to the follower" do
      channel = command :'channels/create', 'something'
      sub_channel = command :'channels/create', 'something2'

      command :"channels/add_subchannel", channel, sub_channel
      interactor :"channels/add_fact", fact, sub_channel

      facts = interactor :'channels/facts', channel.id, nil, nil
      latest_fact = facts.map{|i| i[:item]}[0]
      expect(latest_fact).to eq fact
    end
  end

  context 'with a followed follower' do
    it "should not add the fact to the indirect follower" do
      channel = command :'channels/create', 'something'
      sub_channel = command :'channels/create', 'something2'
      sub_sub_channel = command :'channels/create', 'something3'

      command :"channels/add_subchannel", channel, sub_channel
      command :"channels/add_subchannel", sub_channel, sub_sub_channel

      interactor :"channels/add_fact", fact, sub_sub_channel

      facts = interactor :'channels/facts', channel.id, nil, nil
      expect(facts).to eq []
    end
  end
end
