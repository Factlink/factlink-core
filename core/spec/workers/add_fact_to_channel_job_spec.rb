require 'spec_helper'

describe AddFactToChannelJob do
  describe ".perform" do
    let(:channel) { create :channel }
    let(:fact)    { create :fact    }

    it "adds the channel to fact.channels" do
      AddFactToChannelJob.perform fact.id, channel.id
      fact.channels.all.should =~ [channel]
    end
  end
end
