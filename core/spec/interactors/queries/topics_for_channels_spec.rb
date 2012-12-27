require 'spec_helper'

describe Queries::TopicsForChannels do
  describe :call do
    it 'should retrieve all topics belonging to the channels' do
      ch1 = create :channel, title: 'a'
      ch2 = create :channel, title: 'b'
      ch3 = create :channel, title: 'b'
      t1 = Topic.by_slug 'a'
      t2 = Topic.by_slug 'b'

      query = Queries::TopicsForChannels.new [ch1, ch2, ch3]
      expect(query.call).to eq([t1, t2])
    end
  end
end
