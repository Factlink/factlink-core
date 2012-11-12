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

      MapReduce::TopicAuthority.new.write_output({user_id: gu.id, topic: ch1.slug_title}, 30)
      MapReduce::TopicAuthority.new.write_output({user_id: gu.id, topic: ch2.slug_title}, 50)
      MapReduce::TopicAuthority.new.write_output({user_id: gu.id, topic: ch3.slug_title}, 10)

      subject.editable_channels_by_authority.map(&:title).should == [ch2, ch1, ch3].map(&:title)
    end
    it "should limit the channel to the limit" do
      ch1 = create :channel, created_by: gu
      ch2 = create :channel, created_by: gu
      ch3 = create :channel, created_by: gu

      MapReduce::TopicAuthority.new.write_output({user_id: gu.id, topic: ch1.slug_title}, 30)
      MapReduce::TopicAuthority.new.write_output({user_id: gu.id, topic: ch2.slug_title}, 50)
      MapReduce::TopicAuthority.new.write_output({user_id: gu.id, topic: ch3.slug_title}, 10)

      subject.editable_channels_by_authority(2).map(&:title).should == [ch2, ch1].map(&:title)
    end
  end
end