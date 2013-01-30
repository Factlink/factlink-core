require 'spec_helper'

describe Interactors::Topics::Facts do
  include PavlovSupport
  include Pavlov::Helpers

  before do
    @user1 = create :user
    @user2 = create :user
    @user3 = create :user

    @channel1 = create :channel, title: "Channel Title", created_by: @user1.graph_user
    @channel2 = create :channel, title: "Channel Title", created_by: @user2.graph_user
    @channel3 = create :channel, title: "Channel Title", created_by: @user3.graph_user

    @slug_title = @channel1.slug_title

    @fact1 = create :fact
    @fact2 = create :fact
    @fact3 = create :fact

    interactor :"channels/add_fact", @fact1, @channel1
    interactor :"channels/add_fact", @fact2, @channel2
    interactor :"channels/add_fact", @fact3, @channel3
  end

  it 'returns a list of all facts in all channels in the topic' do
    facts = interactor :"topics/facts", @slug_title, nil, nil

    expect(facts.length).to eq 3
    expect(facts[0][:item].id).to eq @fact3.id
    expect(facts[1][:item].id).to eq @fact2.id
    expect(facts[2][:item].id).to eq @fact1.id
  end

  def pavlov_options
    {
      current_user: true
    }
  end
end