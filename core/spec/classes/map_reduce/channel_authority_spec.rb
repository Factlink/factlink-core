require File.expand_path('../../../../app/classes/map_reduce.rb', __FILE__)
require File.expand_path('../../../../app/classes/map_reduce/channel_authority.rb', __FILE__)

unless defined?(Authority)
  class Authority
  end
end

describe MapReduce::ChannelAuthority do
  describe :wrapped_map do
    it do
      facts = [
        stub(:Fact,
          id: 10,
          created_by_id: 20,
          channel_ids: [10,11],
        ),
        stub(:Fact,
          id: 11,
          created_by_id: 21,
          channel_ids: [10],
        ),
        stub(:Fact,
          id: 12,
          created_by_id: 21,
          channel_ids: [10,11],
        )
      ]
      Authority.stub!(:from).and_return(18)
      subject.wrapped_map(facts).should == {
        {user_id: 20, channel_id:10} => [18],
        {user_id: 21, channel_id:10} => [18,18],
        {user_id: 20, channel_id:11} => [18],
        {user_id: 21, channel_id:11} => [18],
      }
    end
  end
  describe :reduce do
    it { subject.reduce(:a, [10,15]).should == 25 }
  end
end
