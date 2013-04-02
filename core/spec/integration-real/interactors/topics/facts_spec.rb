require 'spec_helper'

describe Interactors::Topics::Facts do
  include PavlovSupport
  include Pavlov::Helpers

  let(:user1) {create :user}
  let(:user2) {create :user}
  let(:user3) {create :user}

  it 'returns a list of all facts in all channels in the topic and gets a valid timestamp for the facts' do
    channel1,facts, fact1, fact2, fact3 = ()
    title = "Channel Title"

    as(user1) do |pavlov|
      channel1 = create :channel, title: title, created_by: user1.graph_user
      fact1 = create :fact
      pavlov.interactor :"channels/add_fact", fact1, channel1
    end

    as(user2) do |pavlov|
      channel2 = create :channel, title: title, created_by: user2.graph_user
      fact2 = create :fact
      pavlov.interactor :"channels/add_fact", fact2, channel2
    end

    as(user3) do |pavlov|
      channel3 = create :channel, title: title, created_by: user3.graph_user
      fact3 = create :fact
      pavlov.interactor :"channels/add_fact", fact3, channel3
    end

    slug_title = channel1.slug_title

    as(user1) do |pavlov|
      facts = pavlov.interactor :"topics/facts", slug_title, nil, nil
    end

    fact_ids = facts.map {|item| item[:item].id }

    expect(fact_ids).to eq [fact3.id, fact2.id, fact1.id]

    expect(facts[0][:score]).to_not eq 0
  end
end
