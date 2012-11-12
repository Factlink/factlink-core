require 'spec_helper'

describe AddFactToChannel do
  describe ".perform" do
    before do
      @ch = create :channel
      @f = create :fact
    end

    it "should add the fact to the cached facts" do
      AddFactToChannel.perform @f.id, @ch.id
      @ch.sorted_cached_facts.should include(@f)
      @f.channels.all.should =~ [@ch]
    end

    it "should add the fact to the all stream of the owner" do
      Resque.should_receive(:enqueue).with(AddFactToChannel, @f.id, @ch.created_by.stream.id, {})

      AddFactToChannel.perform @f.id, @ch.id
    end
    it "should add not add the fact to the all stream of the owner if it is the all stream" do
      Resque.should_not_receive(:enqueue)

      AddFactToChannel.perform @f.id, @ch.created_by.stream.id
    end



    it "should call resque on all its containing channels" do
      sup_ch = create :channel
      @ch.containing_channels << sup_ch

      Resque.should_receive(:enqueue).with(AddFactToChannel, @f.id, sup_ch.id, {})
      Resque.should_receive(:enqueue).with(AddFactToChannel, @f.id, @ch.created_by.stream.id, {})

      AddFactToChannel.perform @f.id, @ch.id
    end

    context "when the channel explicitely deletes the fact" do
      before do
        @ch.sorted_delete_facts << @f
      end

      it "should not add the fact" do
        AddFactToChannel.perform @f.id, @ch.id
        @ch.sorted_cached_facts.should_not include(@f)
        @f.channels.should_not include(@ch)
      end

      it "should not call resque on its containing channels if the channel explicitely deletes the fact" do
        sup_ch = create :channel
        @ch.containing_channels << sup_ch


        Resque.should_not_receive(:enqueue)

        AddFactToChannel.perform @f.id, @ch.id
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

        AddFactToChannel.perform @f.id, @ch.id
      end
    end

  end
end
