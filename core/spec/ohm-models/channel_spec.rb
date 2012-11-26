require 'spec_helper'

describe Channel do
  subject {Channel.create(:created_by => u1, :title => "Subject")}

  let(:ch1) {Channel.create(:created_by => u2, :title => "Something")}
  let(:ch2) {Channel.create(:created_by => u2, :title => "Diddly")}

  let(:u1_ch1) {Channel.create(:created_by => u1, :title => "Something")}
  let(:u1_ch2) {Channel.create(:created_by => u1, :title => "Diddly")}
  let(:u2_ch1) {Channel.create(:created_by => u2, :title => "Something")}
  let(:u2_ch2) {Channel.create(:created_by => u2, :title => "Diddly")}


  let(:u1) { create :graph_user }
  let(:u2) { create :graph_user }
  let(:u3) { create :graph_user }

  let(:f1) { FactoryGirl.create :fact }
  let(:f2) { FactoryGirl.create :fact }
  let(:f3) { FactoryGirl.create :fact }
  let(:f4) { FactoryGirl.create :fact }

  context "activity on a channel" do
    before do
      # TODO: remove this once creating an activity does not cause an email to be sent
      interactor = mock()
      interactor.should_receive(:execute).any_number_of_times
      stub_const 'SendMailForActivityInteractor', Class.new
      SendMailForActivityInteractor.should_receive(:new).any_number_of_times.and_return(interactor)
    end
    
    describe "when adding a subchannel" do
      before do
        subject.add_channel(ch1)
      end
      it { Activity.for(subject).to_a.last.action.should eq "added_subchannel" }
    end
  end

  context "only channels" do
    before do
      # TODO: remove this once activities are not created in the models any more, but in interactors
      stub_const 'Activity::Subject', Class.new
      Activity::Subject.should_receive(:activity).any_number_of_times
    end

    describe "initially" do
      it { subject.containing_channels.to_a.should =~ [] }
    end

    describe "after adding one fact and deleting a fact (not from the Channel but the fact itself) without recalculate" do
      before do
        subject.add_fact(f1)
        f1.delete
        Fact.should_receive(:invalid).with(nil).at_least(:once).and_return(true)
      end
      it { subject.facts.to_a.should =~ []}
    end

    describe "after adding one fact" do
      before do
        subject.add_fact(f1)
        Fact.should_receive(:invalid).any_number_of_times.and_return(false)
      end
      it do
         subject.facts.to_a.should =~ [f1]
      end

      describe "and removing an fact" do
        before do
          subject.remove_fact(f1)
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
          end
          it {subject.facts.to_a.should eq [f2,f1]}
          it {@fork.facts.to_a.should eq [f2,f1]}
        end
        describe "after adding another fact to the fork" do
          before do
             @fork.add_fact(f2)
          end
          it {subject.facts.to_a.should eq [f1]}
          it {@fork.facts.to_a.should eq [f2,f1]}

          describe "after removing the original channel from the fork" do
            before do
              @fork.remove_channel(subject)
            end
            it {@fork.containing_channels.to_a.should =~ []}
            it {@fork.facts.to_a.should eq [f2]}
          end

        end
        describe "after removing the original channel from the fork" do
          before do
            @fork.remove_channel(subject)
          end
          it {@fork.containing_channels.to_a.should =~ []}
          it {@fork.facts.to_a.should eq []}
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
          subject.facts.to_a.should eq [f2,f1]
        end
        it "should return with timestamps when asked" do
          res = subject.facts(withscores:true)
          res[0][:item].should eq f2
          res[1][:item].should eq f1
          res[0][:score].should be_a(Float)
          res[1][:score].should be_a(Float)
        end
        it "should not return more than ask" do
          subject.facts(withscores:true,count:0).length.should eq 0
          subject.facts(withscores:true,count:1).length.should eq 1
          subject.facts(withscores:false,count:0).length.should eq 0
          subject.facts(withscores:false,count:1).length.should eq 1
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
      it "should be removed from the contained_channels when deleted" do
        id = ch1.id
        ch1.add_channel u1_ch1
        ch1.contained_channels.ids.should =~ [u1_ch1.id]

        u1_ch1.real_delete
        ch1.contained_channels.ids.should =~ []
      end
      it "should remove activities" do
        ch1.add_channel u1_ch1
        fakech1 = Channel[ch1.id]
        ch1.add_fact f1
        ch1.real_delete
        Activity.for(fakech1).all.should eq []
      end
      it "should be removed from the graph_users active channels for" do
        subject
        Channel.active_channels_for(u1).should include(subject)
        subject.real_delete
        Channel.active_channels_for(u1).should_not include(subject)
      end
    end

    describe :title= do
      it "should set the title" do
        subject.title = "hasfudurbar"
        subject.title.should  == "hasfudurbar"
      end
      it "should set the lowercase title" do
        subject.title = "HasfudUrbar"
        subject.lowercase_title.should  == "hasfudurbar"
      end
    end

    describe ".for_fact" do
      it "should give all channels which contain a certain fact" do
        ch1
        ch2
        ch1.add_fact f1
        ch1.add_fact f2
        ch2.add_fact f2

        Channel.for_fact(f1).should =~ [ch1]
        Channel.for_fact(f2).should =~ [ch1,ch2]
      end
    end

    describe "save" do
      it "should ensure the topic exists" do
        @ch = FactoryGirl.build :channel
        @ch.save
        Topic.by_title(@ch.title).should_not be_new
      end
    end

    describe 'slugs' do
      it "should not be possible to save two channels with a similar name" do
        @ch1 = FactoryGirl.create :channel, title: 'hoi', created_by: u1
        @ch2 = FactoryGirl.build  :channel, title: 'Hoi', created_by: u1
        @ch2.save
        @ch2.should be_new
      end
    end

    describe :topic do
      it "should get the topic" do
        @ch1 = create :channel, title: 'hoi'
        @ch1.topic.title.should eq 'hoi'
        @ch1.topic.should_not be_new
      end
      it "should get the topic if the topic existed before the channel" do
        @t = create :topic, title: "HoI"
        @ch1 = create :channel, title: 'hoi'
        @ch1.topic.should eq @t
      end
      it "should get the topic even if I removed the topic" do
        @t = create :topic, title: "HoI"
        @ch1 = create :channel, title: 'hoi'
        @t.delete
        @ch1.topic.slug_title.should eq 'hoi'
      end
    end

    describe :facts do
      it "should clean up removed facts" do
        @ch1 = create :channel, title: 'hoi'
        @f1 = create :fact
        @f2 = create :fact
        @ch1.add_fact @f1
        @ch1.add_fact @f2
        @ch1.facts.should =~ [@f1,@f2]
        @ch1.sorted_cached_facts.count.should eq 2
        @f1.delete
        @ch1.facts.should =~ [@f2]
        @ch1.sorted_cached_facts.count.should eq 1

      end
    end

    describe :can_be_added_as_subchannel? do
      it "should be true" do
        subject.can_be_added_as_subchannel?.should be_true
      end
    end

    describe :delete do
      before do
        u1_ch1.add_fact f1
        u2_ch1.add_fact f2
        u1_ch1.add_fact f3
        u2_ch1.add_fact f4
        u1_ch1.add_channel u2_ch1
        u2_ch1.delete
      end
      it "should not remove the facts from the channels which follow this channel" do
        u1_ch1.facts.should =~ [f1,f2,f3,f4]
      end
      it "should not exist anymore" do
        Channel[u2_ch1.id].should be_nil
      end
      it "should not be referred to by other objects"
    end

    describe "new unread count functionality" do
      let(:u1_f1) { FactoryGirl.create :fact, created_by: u1 }
      let(:u2_f1) { FactoryGirl.create :fact, created_by: u2 }

      it "should be zero initially" do
        u1_ch1.unread_count.should eq 0
      end
      it "should be zero after adding fact myself" do
        u1_ch1.add_fact u2_f1
        u1_ch1.unread_count.should eq 0
      end
      context "after a fact was added in a channel I followed" do
        before do
          @ch = u1_ch1
          @ch.add_channel u2_ch1
          u2_ch1.add_fact u2_f1
        end
        it "should be one" do
          @ch.unread_count.should eq 1
        end
        it "after reading, it should be zero" do
          @ch.mark_as_read
          @ch.unread_count.should eq 0
        end
      end
      context "after my own fact was added in a channel I followed" do
        before do
          @ch = u1_ch1
          @ch2 = u1_ch2

          @ch.add_channel u2_ch1
          u2_ch1.add_channel @ch2
          @ch2.add_fact u2_f1
        end
        it "should be zero" do
          @ch.unread_count.should eq 0
        end
      end
      context "when someone is adding my factlink to a channel I follow" do
        before do
          @ch = u1_ch1
          @ch.add_channel u2_ch1
          u2_ch1.add_fact u1_f1
        end
        it "should be zero" do
          @ch.unread_count.should eq 0
        end
      end

    end

    describe "valid_for_activity" do
      it "is false for a channel without facts" do
        ch = create :channel
        expect(ch.valid_for_activity?).to be_false
      end
      it "is false for a channel without facts" do
        ch = create :channel
        ch.add_fact(create :fact)
        expect(ch.valid_for_activity?).to be_true
      end
    end
  end
end
