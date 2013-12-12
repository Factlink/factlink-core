require 'spec_helper'

describe Channel do
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
      stub_const 'Activity', Class.new
      Activity.stub(:create)
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
  end
end
