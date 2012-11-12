require 'spec_helper'

describe AddChannelToChannel do
  describe ".perform" do
    before do
      @ch = create :channel
      @sub_ch = create :channel
      @f = create :fact

      @sub_ch.sorted_cached_facts << @f
    end

    it "should add the fact to the cached facts of the super channel using Resque" do
      Resque.should_receive(:enqueue).with(AddFactToChannel, @f.id, @ch.id)
      AddChannelToChannel.perform @sub_ch.id, @ch.id
    end
  end
end