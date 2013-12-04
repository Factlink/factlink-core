require 'spec_helper'

describe AddFactToChannelJob do
  describe ".perform" do
    let(:channel) { create :channel }
    let(:fact)    { create :fact    }

    it "adds the channel to fact.channels" do
      expect(Pavlov)
        .to receive(:command)
        .with(:"topics/add_fact", fact_id: fact.id, topic_slug_title: channel.slug_title, score: '')

      AddFactToChannelJob.perform fact.id, channel.id
      expect(fact.channels.all).to match_array [channel]
    end
  end
end
