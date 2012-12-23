require 'spec_helper'

describe ChannelList do
  describe ".channels" do
    before do
      @graph_user = create :graph_user
      @expected_channels = []
      begin
        @expected_channels << @graph_user.stream
        @expected_channels << @graph_user.created_facts_channel
      rescue
      end
    end
    describe "initially" do
      it "contains only the expected channels" do
        ChannelList.new(@graph_user).channels.to_a.should =~ []+@expected_channels
      end
    end
    describe "after creating a channel" do
      it "contains the channel and the expected channels" do
        @ch1 = Channel.create created_by: @graph_user, title: 'foo'
        ChannelList.new(@graph_user).channels.to_a.should =~ [@ch1]+@expected_channels
      end
    end
    describe "after creating two channels" do
      it "contains the two channels and the expected channels" do
        @ch1 = Channel.create created_by: @graph_user, title: 'foo'
        @ch2 = Channel.create created_by: @graph_user, title: 'foo2'
        ChannelList.new(@graph_user).channels.to_a.should =~ [@ch1,@ch2]+@expected_channels
      end
    end
    describe "after creating two channels and deleting the first" do
      it "should contain the second channel and the expected channels" do
        @ch1 = Channel.create created_by: @graph_user, title: 'foo'
        @ch2 = Channel.create created_by: @graph_user, title: 'foo2'
        @ch1.delete
        ChannelList.new(@graph_user).channels.to_a.should =~ [@ch2]+@expected_channels
      end
    end
    describe "after creating a channel, and someone else creates a channel" do
      it "only contains our channel, and the expected channels" do
        @ch1 = Channel.create created_by: @graph_user, title: 'foo'
        @ch2 = Channel.create created_by: (create :graph_user), title: 'foo2'

        ChannelList.new(@graph_user).channels.to_a.should =~ [@ch1]+@expected_channels
      end
    end
  end
end
