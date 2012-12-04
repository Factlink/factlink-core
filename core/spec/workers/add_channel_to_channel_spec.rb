require 'spec_helper'

describe AddChannelToChannel do
  describe ".perform" do
    before do
      @ch = create :channel
      @sub_ch = create :channel
    end

    it "should add the fact to the cached facts of the super channel using Resque" do
      fact = create :fact
      @sub_ch.sorted_cached_facts << fact

      Resque.should_receive(:enqueue).with(AddFactToChannelJob, fact.id, @ch.id)
      AddChannelToChannel.perform @sub_ch.id, @ch.id
    end

    it "should only add NUMBER_OF_INITIAL_FACTS facts to the super channel" do
      oldest_fact = create :fact
      @sub_ch.sorted_cached_facts << oldest_fact

      facts = []

      for i in 1..AddChannelToChannel::NUMBER_OF_INITIAL_FACTS
        facts[i] = create :fact
        @sub_ch.sorted_cached_facts << facts[i]
      end

      for i in 1..AddChannelToChannel::NUMBER_OF_INITIAL_FACTS
        Resque.should_receive(:enqueue).with(AddFactToChannelJob, facts[i].id, @ch.id)
      end

      AddChannelToChannel.perform @sub_ch.id, @ch.id
    end
  end
end
