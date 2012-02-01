require 'ohm_helper'

require 'active_support/core_ext/module/delegation'
require_relative '../../app/ohm-models/activity.rb'
require_relative '../../app/ohm-models/channel.rb'

class Basefact < OurOhm;end
class Fact < Basefact;end

unless defined?(GraphUser)
  class GraphUser < OurOhm
    def reposition_in_top_users; end
  end
end



def create_fact
  FactoryGirl.create :fact
rescue
  Fact.create
end

describe Channel do
  subject {Channel.create(:created_by => u1, :title => "Subject")}

  let(:ch1) {Channel.create(:created_by => u2, :title => "Something")}
  let(:ch2) {Channel.create(:created_by => u2, :title => "Diddly")}

  let(:u1_ch1) {Channel.create(:created_by => u1, :title => "Something")}
  let(:u1_ch2) {Channel.create(:created_by => u1, :title => "Diddly")}
  let(:u2_ch1) {Channel.create(:created_by => u2, :title => "Something")}
  let(:u2_ch2) {Channel.create(:created_by => u2, :title => "Diddly")}


  let(:u1) { GraphUser.create }
  let(:u2) { GraphUser.create }
  let(:u3) { GraphUser.create }

  let (:f1) { create_fact }
  let (:f2) { create_fact }
  let (:f3) { create_fact }
  let (:f4) { create_fact }


  context "activity on a channel" do
    describe "when adding a subchannel" do
      before do
        subject.add_channel(ch1)
      end
      it { Activity.for(subject).to_a.last.action.should == "added_subchannel" }
    end
  end

  describe "initially" do
    it { subject.containing_channels.to_a.should =~ [] }
  end

  describe "after adding one fact and deleting a fact (not from the Channel but the fact itself) without recalculate" do
    before do
      subject.add_fact(f1)
      f1.delete
      Fact.should_receive(:invalid).with(f1).and_return(true)
    end
    it { subject.facts.to_a.should =~ []}
  end


  describe "after adding one fact" do
    before do
      subject.add_fact(f1)
      Fact.should_receive(:invalid).any_number_of_times.and_return(false)
      Channel.recalculate_all
    end
    it do
       subject.facts.to_a.should =~ [f1]
    end

    describe "and removing an fact" do
      before do
        subject.remove_fact(f1)
        Channel.recalculate_all
      end
      it { subject.facts.to_a.should =~ []}
    end



    describe "after forking" do
      before do
        @fork = Channel.create created_by: u2, title: "Fork"
        @fork.add_channel(subject)
        @fork.title = "Fork"
        @fork.save
      end

      it {subject.facts.to_a.should =~ [f1]}
      it {@fork.facts.to_a.should =~ [f1]}

      it {subject.containing_channels.to_a.should =~ [@fork]}

      describe "and removing the fact from the original" do
        before do
          subject.remove_fact(f1)
          Channel.recalculate_all
        end
        it {subject.facts.to_a.should =~ []}
        it {subject.sorted_internal_facts.to_a.should =~ []}
        it {subject.sorted_cached_facts.all.to_a.should =~ []}
        it {@fork.sorted_internal_facts.to_a.should =~ []}
        it {@fork.sorted_cached_facts.to_a.should =~ []}
        it {@fork.facts.to_a.should =~ []}
      end
      describe "and removing the fact from the fork" do
        before do
           @fork.remove_fact(f1)
        end
        it {subject.facts.to_a.should =~ [f1]}
        it {@fork.facts.to_a.should =~ []}
      end
      describe "after adding another fact to the original" do
        before do
           subject.add_fact(f2)
           Channel.recalculate_all
        end
        it {subject.facts.to_a.should == [f2,f1]}
        it {@fork.facts.to_a.should == [f2,f1]}
      end
      describe "after adding another fact to the fork" do
        before do
           @fork.add_fact(f2)
        end
        it {subject.facts.to_a.should == [f1]}
        it {@fork.facts.to_a.should == [f2,f1]}

        describe "after removing the original channel from the fork" do
          before do
            @fork.remove_channel(subject)
          end
          it {@fork.containing_channels.to_a.should =~ []}
          it {@fork.facts.to_a.should == [f2]}
        end

      end
      describe "after removing the original channel from the fork" do
        before do
          @fork.remove_channel(subject)
        end
        it {@fork.containing_channels.to_a.should =~ []}
        it {@fork.facts.to_a.should == []}
      end
    end
  end

  describe "after adding a subchannel" do
    before do
      subject.add_channel(ch1)
    end
    it {subject.contained_channels.to_a.should =~ [ch1]}
    it {ch1.containing_channels.to_a.should =~ [subject]}
    describe "after adding another subchannel" do
      before do
        subject.add_channel(ch2)
      end
      it {subject.contained_channels.to_a.should =~ [ch1,ch2]}
      it {ch1.containing_channels.to_a.should =~ [subject]}
      it {ch2.containing_channels.to_a.should =~ [subject]}
      describe "after deleting the first subchannel" do
        before do
          subject.remove_channel(ch1)
        end
        it {subject.contained_channels.to_a.should =~ [ch2]}
        it {ch1.containing_channels.to_a.should =~ []}
        it {ch2.containing_channels.to_a.should =~ [subject]}
      end
    end
  end

  describe "after adding to two channels" do
    before do
      ch1.add_channel subject
      ch2.add_channel subject
    end
    it {subject.containing_channels.to_a.should =~ [ch1,ch2]}
    describe "after removing it from one channel" do
      before do
        ch1.remove_channel subject
      end
      it {subject.containing_channels.to_a.should =~ [ch2]}
    end
  end

  describe "#containing_channels_for" do
    describe "initially" do
      it {subject.containing_channels_for(u1).to_a.should =~ []}
    end
    describe "after adding to a own channel" do
      before do
        u1_ch1.add_channel subject
      end
      it {subject.containing_channels_for(u1).to_a.should =~ [u1_ch1]}
      describe "after adding to someone else's channel" do
        before do
          u1_ch1.add_channel subject
          u2_ch1.add_channel subject
        end
        it {subject.containing_channels_for(u1).to_a.should =~ [u1_ch1]}
      end
    end
  end

  describe "#active_channels_for" do
    before do
      @expected_channels = []
      begin
        @expected_channels << u1.stream
        @expected_channels << u1.created_facts_channel
      rescue
      end
    end
    describe "initially" do
      it {Channel.active_channels_for(u1).to_a.should =~ []+@expected_channels}
    end
    describe "after creating a channel" do
      before do
        @ch1 = Channel.create created_by: u1, title: 'foo'
      end
      it {Channel.active_channels_for(u1).to_a.should =~ [@ch1]+@expected_channels}
      describe "after creating another channel" do
        before do
          @ch2 = Channel.create created_by: u1, title: 'foo2'
        end
        it {Channel.active_channels_for(u1).to_a.should =~ [@ch1,@ch2]+@expected_channels}
        describe "after deleting a channel" do
          before do
            @ch1.delete
          end
          it {Channel.active_channels_for(u1).to_a.should =~ [@ch2]+@expected_channels}
        end
      end
      describe "after someone else creating another channel" do
        before do
          @ch2 = Channel.create created_by: u2, title: 'foo2'
        end
        it {Channel.active_channels_for(u1).to_a.should =~ [@ch1]+@expected_channels}
      end
    end
  end

  describe "#facts" do
    before do
      Fact.should_receive(:invalid).any_number_of_times.and_return(false)
    end
    context "initially" do
      it "should be empty" do
        subject.facts.to_a.should =~ []
        Channel.new.facts.to_a.should =~ []
      end
    end
    context "after adding some facts" do
      before do
        subject.add_fact f1
        sleep(0.01)
        subject.add_fact f2
      end
      it "should contain the facts" do
        subject.facts.to_a.should =~ [f1,f2]
      end
      it "should contain the facts in order" do
        subject.facts.to_a.should == [f2,f1]
      end
      it "should return with timestamps when asked" do
        res = subject.facts(withscores:true)
        res[0][:item].should == f2
        res[1][:item].should == f1
        res[0][:score].should be_a(Float)
        res[1][:score].should be_a(Float)
      end
      it "should not return more than ask" do
        subject.facts(withscores:true,count:0).length.should == 0
        subject.facts(withscores:true,count:1).length.should == 1
        subject.facts(withscores:false,count:0).length.should == 0
        subject.facts(withscores:false,count:1).length.should == 1
      end
    end
  end

  describe "creating a channel" do
    it "should be possible to create a channel given a username and a title" do
      @ch = Channel.create created_by: u1, title: 'foo'
      @ch.should_not be_new
    end
    context "should not be possible to create two channels with the same title" do
      before do
        Channel.create title: "foo", created_by: u1
      end
      it "should not be possible using create" do
        @ch = Channel.create title: "foo", created_by: u1
        @ch.should be_new
        @ch.should_not be_valid
      end
      it "should not be possible using save" do
        @ch = Channel.new title: "foo", created_by: u1
        @ch.should_not be_valid
        @ch.save
        @ch.should be_new
      end
    end
  end

  describe "removing a channel" do
    it "should be possible" do
      id = ch1.id
      Channel[id].should_not be_nil
      ch1.real_delete
      Channel[id].should be_nil
    end
    it "should remove itself from other channels' containing_channels" do
      id = ch1.id
      ch1.add_channel u1_ch1
      u1_ch1.containing_channels.ids.should =~ [id]
      ch1.real_delete
      u1_ch1.containing_channels.ids.should =~ []
    end
    it "should remove activities" do
      fakech1 = Channel.new
      ch1.add_channel u1_ch1
      fakech1.stub(:id,ch1.id)
      ch1.add_fact f1
      ch1.real_delete
      Activity.for(fakech1).all.should == []
    end
    it "should be removed from the graph_users active channels for" do
      subject
      Channel.active_channels_for(u1).should include(subject)
      subject.real_delete
      Channel.active_channels_for(u1).should_not include(subject)
    end
  end

end