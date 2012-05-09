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
  end
end