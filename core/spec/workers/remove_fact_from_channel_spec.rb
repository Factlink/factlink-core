require 'spec_helper'

describe RemoveFactFromChannel do
  describe ".perform" do
    before do
      @ch = create :channel
      @f = create :fact
      @ch.sorted_cached_facts << @f
      @f.channels << @ch
    end

    it "should remove the fact from the cached facts" do
      RemoveFactFromChannel.perform @f.id, @ch.id
      @ch.sorted_cached_facts.should_not include(@f)
      @f.channels.should_not include(@ch)
    end

    context "when the channel itself contains the fact" do
      it "should not remove the fact from the cached facts" do
        @ch.sorted_internal_facts << @f

        RemoveFactFromChannel.perform @f.id, @ch.id
        @ch.sorted_cached_facts.should include(@f)
        @f.channels.should include(@ch)
      end
    end
  end
end
