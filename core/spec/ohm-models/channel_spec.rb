require 'spec_helper'

describe Channel do
  include AddFactToChannelSupport
  subject(:channel) {Channel.create(created_by: u1, title: "Subject")}

  let(:ch1) {Channel.create(created_by: u2, title: "Something")}
  let(:ch2) {Channel.create(created_by: u2, title: "Diddly")}

  let(:u1_ch1) {Channel.create(created_by: u1, title: "Something")}

  let(:u1) { create :graph_user }
  let(:u2) { create :graph_user }

  let(:f1) { create :fact }
  let(:f2) { create :fact }

  context "activity on a channel" do
    before do
      # TODO: remove this once creating an activity does not cause an email to be sent
      send_mail_interactor = stub call: nil
      stub_const 'Interactors::SendMailForActivity', Class.new
      Pavlov.stub(:old_interactor)
        .with(:send_mail_for_activity, an_instance_of(Activity), { current_user: true })
    end

    describe "when adding a subchannel" do
      it "creates an added_subchannel activity" do
        pavlov_options = {ability: (mock can?: true)}
        Interactors::Channels::AddSubchannel.new(channel_id: channel.id,
          subchannel_id: ch1.id, pavlov_options: pavlov_options).call
        last_activity = Activity.for(channel).to_a.last
        expect(last_activity.action).to eq "added_subchannel"
      end
    end
  end

  context "only channels" do
    before do
      # TODO: remove this once activities are not created in the models any more, but in interactors
      stub_const 'Activity::Subject', Class.new
      Activity::Subject.stub(:activity)
    end

    describe "initially" do
      it { channel.containing_channels.to_a.should =~ [] }
    end

    describe "after adding one fact and deleting a fact (not from the Channel but the fact itself) without recalculate" do
      before do
        add_fact_to_channel f1, channel
        f1.delete
        Fact.should_receive(:invalid).with(nil).at_least(:once).and_return(true)
      end
      it { channel.facts.to_a.should =~ []}
    end

    describe "after adding one fact" do
      before do
        add_fact_to_channel f1, channel
        Fact.should_receive(:invalid).any_number_of_times.and_return(false)
      end
      it do
         channel.facts.to_a.should =~ [f1]
      end

      describe "and removing an fact" do
        before do
          channel.remove_fact(f1)
        end
        it { channel.facts.to_a.should =~ []}
      end

      describe "after forking" do
        before do
          @fork = Channel.create created_by: u2, title: "Fork"
          Commands::Channels::AddSubchannel.new(channel: @fork, subchannel: channel).call
          @fork.title = "Fork"
          @fork.save
        end

        it {channel.facts.to_a.should =~ [f1]}
        it {@fork.facts.to_a.should =~ [f1]}

        it {channel.containing_channels.to_a.should =~ [@fork]}

        describe "and removing the fact from the original" do
          before do
            channel.remove_fact(f1)
          end
          it "there are no facts anywhere anymore" do
            channel.facts.to_a.should =~ []
            channel.sorted_internal_facts.to_a.should =~ []
            channel.sorted_cached_facts.all.to_a.should =~ []
            @fork.sorted_internal_facts.to_a.should =~ []
            @fork.sorted_cached_facts.to_a.should =~ []
            @fork.facts.to_a.should =~ []
          end
        end
        describe "and removing the fact from the fork" do
          it "the fact should only be in the original" do
             @fork.remove_fact(f1)

             channel.facts.to_a.should =~ [f1]
             @fork.facts.to_a.should =~ []
          end
        end
        describe "after adding another fact to the original" do
          it "both original and fork should contain the two facts" do
            add_fact_to_channel f2, channel

            channel.facts.to_a.should eq [f2,f1]
            @fork.facts.to_a.should eq [f2,f1]
          end
        end
        describe "after adding another fact to the fork" do
          before do
            add_fact_to_channel f2, @fork
          end
          it "only the fork contains the another fact" do
            channel.facts.to_a.should eq [f1]
            @fork.facts.to_a.should eq [f2,f1]
          end

          describe "after removing the original channel from the fork" do
            it "the fork contains no channels, and only its own facts" do
              Commands::Channels::RemoveSubchannel.new(channel: @fork,
                subchannel: channel).call

              @fork.containing_channels.to_a.should =~ []
              @fork.facts.to_a.should eq [f2]
            end
          end

        end
        describe "after removing the original channel from the fork" do
          it "the fork contains no channels, and no facts" do
            Commands::Channels::RemoveSubchannel.new(channel: @fork,
              subchannel: channel).call

            @fork.containing_channels.to_a.should =~ []
            @fork.facts.to_a.should eq []
          end
        end
      end
    end

    describe "after adding a subchannel" do
      before do
        Commands::Channels::AddSubchannel.new(channel: channel,
          subchannel: ch1).call
      end
      it do
        channel.contained_channels.to_a.should =~ [ch1]
        ch1.containing_channels.to_a.should =~ [channel]
      end
      describe "after adding another subchannel" do
        before do
          Commands::Channels::AddSubchannel.new(channel: channel,
            subchannel: ch2).call
        end
        it do
          channel.contained_channels.to_a.should =~ [ch1,ch2]
          ch1.containing_channels.to_a.should =~ [channel]
          ch2.containing_channels.to_a.should =~ [channel]
        end
        describe "after deleting the first subchannel" do
          it do
            Commands::Channels::RemoveSubchannel.new(channel: channel,
              subchannel: ch1).call

            channel.contained_channels.to_a.should =~ [ch2]
            ch1.containing_channels.to_a.should =~ []
            ch2.containing_channels.to_a.should =~ [channel]
          end
        end
      end
    end

    describe "after adding to two channels" do
      before do
        Commands::Channels::AddSubchannel.new(channel: ch1,
          subchannel: channel).call
        Commands::Channels::AddSubchannel.new(channel: ch2,
          subchannel: channel).call
      end
      it {channel.containing_channels.to_a.should =~ [ch1,ch2]}
      describe "after removing it from one channel" do
        it do
          Commands::Channels::RemoveSubchannel.new(channel: ch1,
            subchannel: channel).call
          channel.containing_channels.to_a.should =~ [ch2]
        end
      end
    end

    describe ".containing_channels_for_ids" do
      it 'calls a method on channellist' do
        channel_list = mock
        return_value = mock
        channel = create :channel
        user = mock
        ChannelList.should_receive(:new).with(user)
                   .and_return(channel_list)
        channel_list.should_receive(:containing_channel_ids_for_channel)
                    .with(channel).and_return(return_value)

        expect(channel.containing_channels_for_ids(user))
           .to eq return_value

      end
    end

    describe "#facts" do
      before do
        Fact.should_receive(:invalid).any_number_of_times.and_return(false)
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
      it "should remove itself from other channels' containing_channels" do
        id = ch1.id
        Commands::Channels::AddSubchannel.new(channel: ch1, subchannel: u1_ch1).call
        u1_ch1.containing_channels.ids.should =~ [id]
        ch1.delete
        u1_ch1.containing_channels.ids.should =~ []
      end
      it "should be removed from the contained_channels when deleted" do
        id = ch1.id
        Commands::Channels::AddSubchannel.new(channel: ch1, subchannel: u1_ch1).call
        ch1.contained_channels.ids.should =~ [u1_ch1.id]

        u1_ch1.delete
        ch1.contained_channels.ids.should =~ []
      end
      it "should remove activities" do
        Commands::Channels::AddSubchannel.new(channel: ch1, subchannel: u1_ch1).call
        fakech1 = Channel[ch1.id]
        add_fact_to_channel f1, ch1
        ch1.delete
        Activity.for(fakech1).all.should eq []
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
        ch1 = create :channel, title: 'hoi', created_by: u1
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

    describe :is_real_channel? do
      its(:is_real_channel?) { should be_true }
    end

    describe :delete do
      let(:u2_ch1) {Channel.create(created_by: u2, title: "Something")}

      before do
        add_fact_to_channel f1, u1_ch1
        add_fact_to_channel f2, u2_ch1
        Commands::Channels::AddSubchannel.new(channel: u1_ch1, subchannel: u2_ch1).call
        u2_ch1.delete
      end
      it "should not remove the facts from the channels which follow this channel" do
        u1_ch1.facts.should =~ [f1,f2]
      end
      it "should not exist anymore" do
        Channel[u2_ch1.id].should be_nil
      end
    end
  end
end
