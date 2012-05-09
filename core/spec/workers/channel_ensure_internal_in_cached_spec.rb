require 'spec_helper'

describe ChannelEnsureInternalInCached do
  describe ".perform" do
    it "should work" do
      ch1 = create :channel
      f1 = create :fact
      ch1.sorted_internal_facts << f1
      ChannelEnsureInternalInCached.perform ch1.id
      ch1.sorted_cached_facts.should include(f1)
    end
    it "should not change the score" do
      ch1 = create :channel
      f1 = create :fact
      ch1.sorted_cached_facts.add f1, 10
      ch1.sorted_internal_facts.add f1, 30
      ChannelEnsureInternalInCached.perform ch1.id
      ch1.sorted_cached_facts.below('inf',withscores:true).should =~ [{item: f1, score: 10}]
    end
  end
end