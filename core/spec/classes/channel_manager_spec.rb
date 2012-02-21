require 'spec_helper'

describe ChannelManager do
  let (:gu) { GraphUser.create }
  subject   { ChannelManager.new gu }
  
  describe :editable_channels_by_authority do
    it "should return an empty list when the graph_user has no channels" do
      subject.editable_channels_by_authority.should == []
    end
    it "should return the channels ordered by authority of the user on the topic" do
      ch1 = create :channel, created_by: gu
      ch2 = create :channel, created_by: gu
      ch3 = create :channel, created_by: gu
      
      Authority.from(Topic.by_title(ch1.title), for: gu) << 30
      Authority.from(Topic.by_title(ch2.title), for: gu) << 50
      Authority.from(Topic.by_title(ch3.title), for: gu) << 10
      
      subject.editable_channels_by_authority.should == [ch2, ch1, ch3]
    end
    it "should limit the channel to the limit" do
      ch1 = create :channel, created_by: gu
      ch2 = create :channel, created_by: gu
      ch3 = create :channel, created_by: gu
      
      Authority.from(Topic.by_title(ch1.title), for: gu) << 30
      Authority.from(Topic.by_title(ch2.title), for: gu) << 50
      Authority.from(Topic.by_title(ch3.title), for: gu) << 10
      
      subject.editable_channels_by_authority(2).should == [ch2, ch1]
    end
  end
end