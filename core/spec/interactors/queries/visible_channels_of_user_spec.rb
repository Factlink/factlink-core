require 'spec_helper'

describe Queries::VisibleChannelsOfUser do
  describe '.call' do
    it "should return the channels" do
      user = create :user
      gu1 = user.graph_user
      create :channel, created_by: gu1, title: 'a'
      create :channel, created_by: gu1, title: 'b'
      create :channel, created_by: gu1, title: 'c'

      pavlov_options = {current_user: user}
      query = described_class.new user: user, pavlov_options: pavlov_options

      expect(query.call.map(&:title))
        .to eq ['a', 'b', 'c']
    end
  end
end
