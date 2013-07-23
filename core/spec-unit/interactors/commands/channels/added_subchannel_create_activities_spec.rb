require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/channels/added_subchannel_create_activities.rb'

describe Commands::Channels::AddedSubchannelCreateActivities do
  include PavlovSupport

  it "should create relevant actities" do
    channel = mock created_by: mock
    subchannel = mock

    stub_classes 'Channel::Activities'
    channel_activities = mock

    Channel::Activities.stub(:new).with(channel)
                       .and_return(channel_activities)

    command = described_class.new channel: channel, subchannel: subchannel

    channel_activities.should_receive(:add_created)
    channel.should_receive(:activity)
           .with(channel.created_by,
                 :added_subchannel, subchannel,
                 :to, channel)

    command.call
  end
end
