require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/channels/added_subchannel_create_activities.rb'

describe Commands::Channels::AddedSubchannelCreateActivities do
  include PavlovSupport

  it "should create relevant actities" do
    channel = double created_by: double
    subchannel = double

    stub_classes 'Channel::Activities'
    channel_activities = double

    Channel::Activities.stub(:new).with(channel)
                       .and_return(channel_activities)

    command = described_class.new channel: channel

    channel_activities.should_receive(:add_created)

    command.call
  end
end
