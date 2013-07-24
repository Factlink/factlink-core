require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/facts/containing_channel_ids_for_user.rb'

describe Queries::Facts::ContainingChannelIdsForUser do

  it "should retrieve the ids of the channels of the current user which contain this fact" do
    stub_const('ChannelList',Class.new)
    user = double(:user, graph_user: double)
    fact = double(:fact, id: '3')
    containing_channel_ids = double(:channel_ids)
    channel_list = double(:channel_list)

    query = described_class.new(fact: fact,
      pavlov_options: { current_user: user })

    ChannelList.stub(:new).with(user.graph_user)
               .and_return(channel_list)
    channel_list.stub(:containing_real_channel_ids_for_fact)
                .with(fact)
                .and_return(containing_channel_ids)

    expect(query.call).to eq containing_channel_ids
  end
end
