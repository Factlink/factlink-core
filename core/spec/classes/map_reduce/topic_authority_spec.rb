require 'spec_helper'

describe MapReduce::TopicAuthority do
  include AddFactToChannelSupport
  let(:gu1) {create(:user).graph_user}
  let(:gu2) {create(:user).graph_user}

  before do
    stub_const 'Interactors::SendMailForActivity', Class.new
    Interactors::SendMailForActivity.stub(new: double(call: nil),
      attribute_set: [double(name:'pavlov_options'),double(name: 'activity')])
  end

  describe "#wrapped_map" do
     it do
       ch1 = Channel.create(title: "Ruby", created_by: gu1)
       ch2 = Channel.create(title: "Ruby", created_by: gu2)
       ch3 = Channel.create(title: "Java", created_by: gu1)

       channels_all = double ids: [ch1.id, ch2.id, ch3.id]

       Authority.from(ch1, for: gu1) << 2
       Authority.from(ch2, for: gu1) << 3
       Authority.from(ch2, for: gu2) << 4
       Authority.from(ch3, for: gu2) << 5

       result = subject.wrapped_map(channels_all)

       result[{topic: ch1.slug_title, user_id: gu1.id}].should == [2.0, 3.0]
       result[{topic: ch2.slug_title, user_id: gu2.id}].should == [4.0]
       result[{topic: ch3.slug_title, user_id: gu2.id}].should == [5.0]
       result.length.should == 3
     end

     it "gives you credit if you add facts" do
       ch1 = Channel.create(title: "Ruby", created_by: gu1)

       channels_all = double ids: [ch1.id]

       add_fact_to_channel create(:fact), ch1
       add_fact_to_channel create(:fact), ch1
       add_fact_to_channel create(:fact), ch1
       add_fact_to_channel create(:fact), ch1
       add_fact_to_channel create(:fact), ch1

       result = subject.wrapped_map(channels_all)

       result[{topic: ch1.slug_title, user_id: gu1.id}].should == [0.5]
       result.length.should == 1
     end

     it "gives you credit if your channels are followed by other channels" do
       ch1 = Channel.create(title: "Ruby", created_by: gu1)

       channels_all = double ids: [ch1.id]

       10.times do
         ch = create :channel
         Commands::Channels::AddSubchannel.new(channel: ch,
          subchannel: ch1).call
       end

       result = subject.wrapped_map(channels_all)

       result[{topic: ch1.slug_title, user_id: gu1.id}].should == [10]
       result.length.should == 1
     end
   end

   describe "#reduce" do
     it do
       subject.reduce(:foo, [1,2,3]).should == 6.0
     end
   end

   describe "#write_output" do
     it "should add the user to the top_users of the topic" do
       Topic.get_or_create_by_channel(Channel.create(created_by: gu1, title: 'Foo'))
       subject.write_output({user_id: gu1.id, topic: 'foo'}, 10)
       Topic.by_slug('foo').top_users(3).should =~ [gu1.user]
     end
   end
end
