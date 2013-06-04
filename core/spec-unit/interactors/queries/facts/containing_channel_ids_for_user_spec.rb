require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/facts/containing_channel_ids_for_user.rb'

describe Queries::Facts::ContainingChannelIdsForUser do

  it "should retrieve the ids of the channels of the current user which contain this fact" do
    stub_const('ChannelList',Class.new)

    user = mock :user, graph_user: mock
    fact = mock :fact, id: '3'

    containing_channel_ids = mock :channel_ids
    channel_list = mock :channel_list
    ChannelList.stub(:new).with(user.graph_user)
               .and_return(channel_list)
    channel_list.stub(:containing_real_channel_ids_for_fact)
                .with(fact)
                .and_return(containing_channel_ids)

    query = Queries::Facts::ContainingChannelIdsForUser.new fact, current_user: user

    expect(query.call).to eq containing_channel_ids
  end
end
