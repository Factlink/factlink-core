require 'pavlov_helper'
require_relative '../../app/workers/remove_channel_from_channel'

describe RemoveChannelFromChannel do
  include PavlovSupport
  before do
    stub_classes 'Channel',
                 'Resque',
                 'RemoveFactFromChannel'
  end

  describe ".perform" do
    it "should add the fact to the cached facts of the super channel using Resque" do
      ch = mock :channel, id: 10
      sub_ch = mock :sub_channel, id: 15
      fact = mock :fact, id: 78

      sub_ch.stub sorted_cached_facts: [fact]

      Channel.stub(:[]).with(ch.id).and_return(ch)
      Channel.stub(:[]).with(sub_ch.id).and_return(sub_ch)


      Resque.should_receive(:enqueue).with(RemoveFactFromChannel, fact.id, ch.id)

      RemoveChannelFromChannel.perform sub_ch.id, ch.id
    end
  end
end
