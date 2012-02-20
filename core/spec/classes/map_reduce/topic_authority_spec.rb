require_relative '../../ohm_helper.rb'
require File.expand_path('../../../../app/classes/map_reduce.rb', __FILE__)
require File.expand_path('../../../../app/classes/map_reduce/topic_authority.rb', __FILE__)
require_relative '../../../app/ohm-models/authority.rb'

describe MapReduce::TopicAuthority do
  let(:gu1) {GraphUser.create}
  let(:gu2) {GraphUser.create}

  before do
    unless defined?(GraphUser)
      class GraphUser < OurOhm; end
    end
    unless defined?(Channel)
      class Channel < OurOhm;
        attribute :title
        reference :created_by, GraphUser
      end
    end
  end

  describe :wrapped_map do
     it do
       ch1 = Channel.create(title: "Ruby", created_by: gu1)
       ch2 = Channel.create(title: "Ruby", created_by: gu2)
       ch3 = Channel.create(title: "Java", created_by: gu1)
       channels = [ch1,ch2,ch3]

       Authority.from(ch1, for: gu1) << 2
       Authority.from(ch2, for: gu1) << 3
       Authority.from(ch2, for: gu2) << 4
       Authority.from(ch3, for: gu2) << 5

       result = subject.wrapped_map(channels)

       result[{topic: "Ruby", user_id: gu1.id}].should == [2.0, 3.0]
       result[{topic: "Ruby", user_id: gu2.id}].should == [4.0]
       result[{topic: "Java", user_id: gu2.id}].should == [5.0]
       result.length.should == 3
     end
   end
   describe :reduce do
     it do
       subject.reduce(:foo, [1,2,3]).should == 6.0
     end
   end
end
