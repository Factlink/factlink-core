require 'spec_helper'

describe Channel do
  include AddFactToChannelSupport
  subject(:channel) { Channel.create(created_by: u1, title: "Subject") }

  let(:ch1) { Channel.create(created_by: u2, title: "Something") }
  let(:ch2) { Channel.create(created_by: u2, title: "Diddly") }

  let(:u1_ch1) { Channel.create(created_by: u1, title: "Something") }

  let(:u1) { create :graph_user }
  let(:u2) { create :graph_user }

  let(:f1) { create :fact }
  let(:f2) { create :fact }

  context "activity on a channel" do
    before do
      # TODO: remove this once creating an activity does not cause an email to be sent
      stub_const 'Interactors::SendMailForActivity', Class.new
      Pavlov.stub(:interactor).with(:send_mail_for_activity, activity: an_instance_of(Activity), pavlov_options: { current_user: true })
    end
  end

  context "only channels" do
    before do
      # TODO: remove this once activities are not created in the models any more, but in interactors
      stub_const 'Activity::Subject', Class.new
      Activity::Subject.stub(:activity)
    end

    describe "after adding one fact and deleting a fact (not from the Channel but the fact itself) without recalculate" do
      it do
        add_fact_to_channel f1, channel
        f1.delete
        Fact.should_receive(:invalid).with(nil).at_least(:once).and_return(true)
        channel.facts.to_a.should =~ []
      end
    end

    describe "after adding one fact" do
      before do
        add_fact_to_channel f1, channel
        Fact.stub invalid: false
      end

      it do
        channel.facts.to_a.should =~ [f1]
      end

      describe "and removing an fact" do
        before do
          channel.remove_fact(f1)
          channel.facts.to_a.should =~ []
        end
      end
    end

    describe "#facts" do
      before do
        Fact.stub invalid: false
      end

      context "initially" do
        it "should be empty" do
          channel.facts.to_a.should =~ []
          Channel.new.facts.to_a.should =~ []
        end
      end

      context "after adding some facts" do
        before do
          add_fact_to_channel f1, channel
          sleep(0.01)
          add_fact_to_channel f2, channel
        end

        it "should contain the facts in order" do
          channel.facts.to_a.should eq [f2,f1]
        end

        it "should return with timestamps when asked" do
          res = channel.facts(withscores:true)
          res[0][:item].should eq f2
          res[1][:item].should eq f1
          res[0][:score].should be_a(Float)
          res[1][:score].should be_a(Float)
        end

        it "should not return more than ask" do
          channel.facts(withscores:true,count:0).length.should eq 0
          channel.facts(withscores:true,count:1).length.should eq 1
          channel.facts(withscores:false,count:0).length.should eq 0
          channel.facts(withscores:false,count:1).length.should eq 1
        end
      end
    end

    describe "creating a channel" do
      it "should be possible to create a channel given a username and a title" do
        ch = Channel.create created_by: u1, title: 'foo'
        ch.should_not be_new
      end

      context "should not be possible to create two channels with the same title" do
        before do
          Channel.create title: "foo", created_by: u1
        end

        it "should not be possible using create" do
          ch = Channel.create title: "foo", created_by: u1
          ch.should be_new
          ch.should_not be_valid
        end

        it "should not be possible using save" do
          ch = Channel.new title: "foo", created_by: u1
          ch.should_not be_valid
          ch.save
          ch.should be_new
        end
      end
    end

    describe "removing a channel" do
      it "should be possible" do
        id = ch1.id
        Channel[id].should_not be_nil
        ch1.delete
        Channel[id].should be_nil
      end

      it "should be removed from the graph_users active channels for" do
        channel
        ChannelList.new(u1).channels.should include(channel)
        channel.delete
        ChannelList.new(u1).channels.should_not include(channel)
      end
    end

    describe :title= do
      it "should set the title" do
        channel.title = "hasfudurbar"
        channel.title.should  == "hasfudurbar"
      end

      it "should set the lowercase title" do
        channel.title = "HasfudUrbar"
        channel.lowercase_title.should  == "hasfudurbar"
      end
    end

    describe "save" do
      it "should ensure the topic exists" do
        ch = build :channel
        ch.save
        Topic.by_slug(ch.slug_title).should_not be_nil
        Topic.by_slug(ch.slug_title).should_not be_new_record
      end
    end

    describe 'slugs' do
      it "should not be possible to save two channels with a similar name" do
        create :channel, title: 'hoi', created_by: u1
        ch2 = FactoryGirl.build  :channel, title: 'Hoi', created_by: u1
        ch2.save
        ch2.should be_new
      end
    end

    describe :topic do
      it "should get the topic" do
        ch1 = create :channel, title: 'hoi'

        ch1.topic.title.should eq 'hoi'
        ch1.topic.should_not be_new_record
      end

      it "should get the topic if the topic existed before the channel" do
        t = create :topic, title: "HoI"
        ch1 = create :channel, title: 'hoi'

        ch1.topic.should eq t
      end

      it "should get the topic even if I removed the topic" do
        t = create :topic, title: "HoI"
        ch1 = create :channel, title: 'hoi'
        t.delete

        ch1.topic.slug_title.should eq 'hoi'
      end
    end

    describe :facts do
      it "should clean up removed facts" do
        ch1 = create :channel, title: 'hoi'
        f1 = create :fact
        f2 = create :fact
        add_fact_to_channel f1, ch1
        add_fact_to_channel f2, ch1

        f1.delete

        ch1.facts.should =~ [f2]
        ch1.sorted_cached_facts.count.should eq 1
      end
    end
  end
end
