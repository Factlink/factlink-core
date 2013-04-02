require 'spec_helper'

describe RemoveChannelFromChannel do
  describe ".perform" do
    it "should add the fact to the cached facts of the super channel using Resque" do
      ch = create :channel
      sub_ch = create :channel
      fact = create :fact

      sub_ch.sorted_cached_facts << fact

      Resque.should_receive(:enqueue).with(RemoveFactFromChannel, fact.id, ch.id)
      RemoveChannelFromChannel.perform sub_ch.id, ch.id
    end
  end
end
