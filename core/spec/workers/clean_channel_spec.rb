require 'spec_helper'

describe CleanChannel do
  include AddFactToChannelSupport
  describe ".perform" do
    before do
      @ch = create :channel
      @f1 = create :fact
      @f2 = create :fact
      @f3 = create :fact

      add_fact_to_channel @f1, @ch
      add_fact_to_channel @f2, @ch
      add_fact_to_channel @f3, @ch
    end

    it "should not do anything if no facts were deleted" do
      CleanChannel.perform @ch.id
      @ch.sorted_cached_facts.count.should == 3
      @ch.sorted_internal_facts.count.should == 3
    end

    it "should remove deleted facts" do
      @f1.delete
      CleanChannel.perform @ch.id
      @ch.sorted_cached_facts.count.should == 2
      @ch.sorted_internal_facts.count.should == 2
      @ch.facts.should =~ [@f2, @f3]
      @f2.delete
      CleanChannel.perform @ch.id
      @ch.sorted_cached_facts.count.should == 1
      @ch.sorted_internal_facts.count.should == 1
      @ch.facts.should =~ [@f3]
    end
  end
end
