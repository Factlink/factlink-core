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

    context "when the channel explicitely deletes the fact" do
      before do
        channel.sorted_delete_facts << fact
      end

      it "should not add the fact" do
        AddFactToChannelJob.perform fact.id, channel.id
        channel.sorted_cached_facts.should_not include(fact)
        fact.channels.should_not include(channel)
      end

      it "should not call resque on its containing channels if the channel explicitely deletes the fact" do
        sup_ch = create :channel
        channel.containing_channels << sup_ch


        Resque.should_not_receive(:enqueue)

        AddFactToChannelJob.perform fact.id, channel.id
      end
    end

    context "when the channel cached facts already included the fact" do
      before do
        channel.sorted_cached_facts << fact
      end

      it "should not call resque on its containing channels if the channel explicitely deletes the fact" do
        sup_ch = create :channel
        channel.containing_channels << sup_ch


        Resque.should_not_receive(:enqueue)

        AddFactToChannelJob.perform fact.id, channel.id
      end
    end

  end
end
