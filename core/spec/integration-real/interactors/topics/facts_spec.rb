require 'spec_helper'

describe Interactors::Topics::Facts do
  include PavlovSupport

  let(:user1) {create :user}
  let(:user2) {create :user}
  let(:user3) {create :user}

  it 'returns a list of all facts in all channels in the topic and gets a valid timestamp for the facts' do
    channel1,facts, fact1, fact2, fact3 = ()
    title = "Channel Title"

    as(user1) do |pavlov|
      channel1 = pavlov.command(:'channels/create', title: title)
      fact1 = pavlov.interactor(:'facts/create', displaystring: 'a fact', url: '', title: '', sharing_options: {})
      pavlov.interactor(:'channels/add_fact', fact: fact1, channel: channel1)
    end

    as(user2) do |pavlov|
      channel2 = pavlov.command(:'channels/create', title: title)
      fact2 = pavlov.interactor(:'facts/create', displaystring: 'a fact', url: '', title: '', sharing_options: {})
      pavlov.interactor(:'channels/add_fact', fact: fact2, channel: channel2)
    end

    as(user3) do |pavlov|
      channel3 = pavlov.command(:'channels/create', title: title)
      fact3 = pavlov.interactor(:'facts/create', displaystring: 'a fact', url: '', title: '', sharing_options: {})
      pavlov.interactor(:'channels/add_fact', fact: fact3, channel: channel3)
    end

    slug_title = channel1.slug_title

    as(user1) do |pavlov|
      facts = pavlov.interactor(:'topics/facts', slug_title: slug_title, count: nil, max_timestamp: nil)
    end

    fact_ids = facts.map {|item| item[:item].id }

    expect(fact_ids).to eq [fact3.id, fact2.id, fact1.id]

    expect(facts[0][:score]).to_not eq 0
  end
end
