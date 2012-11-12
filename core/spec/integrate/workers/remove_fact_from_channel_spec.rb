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

    it "should call resque on all its containing channels" do
      sup_ch = create :channel
      @ch.containing_channels << sup_ch

      Resque.should_receive(:enqueue).with(RemoveFactFromChannel, @f.id, sup_ch.id)

      RemoveFactFromChannel.perform @f.id, @ch.id
    end


    context "when the channel has another channel which contains the same fact" do
      before do
        @subch = create :channel
        @subch.sorted_cached_facts << @f
        @ch.contained_channels << @subch
      end

      it "should not remove the fact from the cached facts" do
        RemoveFactFromChannel.perform @f.id, @ch.id
        @ch.sorted_cached_facts.should include(@f)
      end

      context "when it is in the delete_facts" do
        before do
          @ch.sorted_delete_facts << @f
        end

        it "should remove the fact from the cached facts" do
          RemoveFactFromChannel.perform @f.id, @ch.id
          @ch.sorted_cached_facts.should_not include(@f)
          @f.channels.should_not include(@ch)
        end
      end
    end
    
    context "when the channel itself contains the fact" do
      before do
        @ch.sorted_internal_facts << @f
      end
      it "should not remove the fact from the cached facts" do
        RemoveFactFromChannel.perform @f.id, @ch.id
        @ch.sorted_cached_facts.should include(@f)
        @f.channels.should include(@ch)
      end
    end

    context "when the channel already does not include the fact" do
      before do
        @ch.sorted_cached_facts.delete @f
      end

      it "should not call resque on all its containing channels" do
        sup_ch = create :channel
        @ch.containing_channels << sup_ch

        Resque.should_not_receive(:enqueue)

        RemoveFactFromChannel.perform @f.id, @ch.id
      end

      context "but it was explicitely deleted" do
        before do
          @ch.sorted_delete_facts.add @f
        end
        it "should still remove the channel from the facts channellist" do
          Fact.should_receive(:[]).with(@f.id).and_return(@f)
          @f.channels.should_receive(:delete).with(@ch)
          RemoveFactFromChannel.perform @f.id, @ch.id
        end
        it "should not call resque on all its containing channels" do
          sup_ch = create :channel
          @ch.containing_channels << sup_ch

          Resque.should_not_receive(:enqueue)

          RemoveFactFromChannel.perform @f.id, @ch.id
        end
      end
    end
  end
end