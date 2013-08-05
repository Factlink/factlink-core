require 'spec_helper'
describe Queries::VisibleChannelsOfUser do


  describe '.real_channels_for' do
    it "should return the channels without All and Created" do
      gu1 = create :graph_user
      ch1 = create :channel, created_by: gu1, title: 'a'
      ch2 = create :channel, created_by: gu1, title: 'b'
      ch3 = create :channel, created_by: gu1, title: 'c'

      query = Queries::VisibleChannelsOfUser.new {}

      expect(query.real_channels_for(gu1).map(&:title)).
        to eq ['a', 'b', 'c']
    end
  end
end
