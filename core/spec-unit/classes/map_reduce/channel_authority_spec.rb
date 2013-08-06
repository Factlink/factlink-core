require 'pavlov_helper'
require_relative '../../../app/classes/map_reduce.rb'
require_relative '../../../app/classes/map_reduce/channel_authority.rb'


describe MapReduce::ChannelAuthority do
  include PavlovSupport

  before do
    stub_classes 'Authority', 'Fact'
  end

  describe "#wrapped_map" do
    it do
      facts = double ids: [10, 11, 12]

      fact_db = {
        10 => double(:Fact,
          id: 10,
          created_by_id: 20,
          channel_ids: [10,11],
        ),
        11 => double(:Fact,
          id: 11,
          created_by_id: 21,
          channel_ids: [10],
        ),
        12 => double(:Fact,
          id: 12,
          created_by_id: 21,
          channel_ids: [10,11],
        )
      }

      Authority.stub(:from).and_return(double(:Authority, to_f: 18))
      Fact.stub(:[]) { |id| fact_db[id] }

      subject.wrapped_map(facts).should == {
        {graph_user_id: 20, channel_id:10} => [18],
        {graph_user_id: 21, channel_id:10} => [18,18],
        {graph_user_id: 20, channel_id:11} => [18],
        {graph_user_id: 21, channel_id:11} => [18],
      }
    end
  end

  describe "#reduce" do
    it { subject.reduce(:a, [10,15]).should == 25 }
  end
end
