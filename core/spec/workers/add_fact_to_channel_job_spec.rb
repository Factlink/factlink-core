require 'spec_helper'

describe AddFactToChannelJob do
  describe ".perform" do
    let(:channel) { create :channel }
    let(:fact)    { create :fact    }

    it "should add the fact to the cached facts" do
      AddFactToChannelJob.perform fact.id, channel.id
      channel.sorted_cached_facts.should include(fact)
      fact.channels.all.should =~ [channel]
    end
  end
end
