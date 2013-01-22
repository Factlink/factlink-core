require 'spec_helper'

describe AddFactToChannelJob do
  describe ".perform" do
    before do
      @ch = create :channel
      @f = create :fact
    end

    it "should add the fact to the cached facts" do
      AddFactToChannelJob.perform @f.id, @ch.id
      @ch.sorted_cached_facts.should include(@f)
      @f.channels.all.should =~ [@ch]
    end
    it "should call resque on all its containing channels" do
      sup_ch = create :channel
      @ch.containing_channels << sup_ch

      Resque.should_receive(:enqueue).with(AddFactToChannelJob, @f.id, sup_ch.id, {})

      AddFactToChannelJob.perform @f.id, @ch.id
    end

    context "when the channel explicitely deletes the fact" do
      before do
        @ch.sorted_delete_facts << @f
      end

      it "should not add the fact" do
        AddFactToChannelJob.perform @f.id, @ch.id
        @ch.sorted_cached_facts.should_not include(@f)
        @f.channels.should_not include(@ch)
      end

      it "should not call resque on its containing channels if the channel explicitely deletes the fact" do
        sup_ch = create :channel
        @ch.containing_channels << sup_ch


        Resque.should_not_receive(:enqueue)

        AddFactToChannelJob.perform @f.id, @ch.id
      end
    end

    context "when the channel cached facts already included the fact" do
      before do
        @ch.sorted_cached_facts << @f
      end

      it "should not call resque on its containing channels if the channel explicitely deletes the fact" do
        sup_ch = create :channel
        @ch.containing_channels << sup_ch


        Resque.should_not_receive(:enqueue)

        AddFactToChannelJob.perform @f.id, @ch.id
      end
    end

  end
end
