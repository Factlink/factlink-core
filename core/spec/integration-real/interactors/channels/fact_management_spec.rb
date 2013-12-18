require 'spec_helper'

describe 'channel facts management' do
  include PavlovSupport

  let(:user) { create :full_user }
  it "adds the fact to the channel" do
    as(user) do |pavlov|
      fact = pavlov.interactor :'facts/create', displaystring: 'a fact', url: '', title: ''

      channel = pavlov.command :'channels/create', title: 'something'
      pavlov.interactor :'channels/add_fact', fact: fact, channel: channel

      expect(channel).to include(fact)
    end
  end

  it "adds the fact to the channels topic" do
    as(user) do |pavlov|
      fact = pavlov.interactor :'facts/create', displaystring: 'a fact', url: '', title: ''

      channel = pavlov.command :'channels/create', title: 'something'
      pavlov.interactor :'channels/add_fact', fact: fact, channel: channel

      Topic.get_or_create_by_channel(channel)
      facts = pavlov.interactor :'topics/facts', slug_title: channel.slug_title, count: nil, max_timestamp: nil
      fact_displaystrings = facts.map { |f| f[:item].data.displaystring }

      expect(fact_displaystrings).to eq ['a fact']
    end
  end
end
