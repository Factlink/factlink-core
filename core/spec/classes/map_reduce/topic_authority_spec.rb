require 'spec_helper'

describe MapReduce::TopicAuthority do
  let(:gu1) {create(:user).graph_user}
  let(:gu2) {create(:user).graph_user}

  before do
    stub_const('SendMailForActivityInteractor', mock())
    SendMailForActivityInteractor.stub(new: nil.andand)
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

       result[{topic: ch1.slug_title, user_id: gu1.id}].should == [2.0, 3.0]
       result[{topic: ch2.slug_title, user_id: gu2.id}].should == [4.0]
       result[{topic: ch3.slug_title, user_id: gu2.id}].should == [5.0]
       result.length.should == 3
     end
     it "should give you credit if you add facts" do
       ch1 = Channel.create(title: "Ruby", created_by: gu1)
       channels = [ch1]

       ch1.add_fact create(:fact)
       ch1.add_fact create(:fact)
       ch1.add_fact create(:fact)
       ch1.add_fact create(:fact)
       ch1.add_fact create(:fact)

       result = subject.wrapped_map(channels)

       result[{topic: ch1.slug_title, user_id: gu1.id}].should == [0.5]
       result.length.should == 1
     end
     it "should give you credit if your channels are followed by other channels" do
       ch1 = Channel.create(title: "Ruby", created_by: gu1)
       channels = [ch1]

       1.upto(10) do |i|
         ch = create :channel
         ch.add_channel ch1
       end

       result = subject.wrapped_map(channels)

       result[{topic: ch1.slug_title, user_id: gu1.id}].should == [10]
       result.length.should == 1
     end
   end
   describe :reduce do
     it do
       subject.reduce(:foo, [1,2,3]).should == 6.0
     end
   end

   describe :write_output do
     it "should add the user to the top_users of the topic" do
       Topic.ensure_for_channel(Channel.create(created_by: gu1, title: 'Foo'))
       subject.write_output({user_id: gu1.id, topic: 'foo'}, 10)
       Topic.by_title('foo').top_users(3).should =~ [gu1.user]
     end
   end
end
