require 'spec_helper'

describe ChannelList do
  before do
    @graph_user = create :graph_user
    @expected_channels = []
    begin
      @expected_channels << @graph_user.stream
      @expected_channels << @graph_user.created_facts_channel
    rescue
    end
  end

  describe ".channels" do
    describe "initially" do
      it "contains only the expected channels" do
        ChannelList.new(@graph_user).channels.to_a.should =~ []+@expected_channels
      end
    end
    describe "after creating a channel" do
      it "contains the channel and the expected channels" do
        @ch1 = Channel.create created_by: @graph_user, title: 'foo'
        ChannelList.new(@graph_user).channels.to_a.should =~ [@ch1]+@expected_channels
      end
    end
    describe "after creating two channels" do
      it "contains the two channels and the expected channels" do
        @ch1 = Channel.create created_by: @graph_user, title: 'foo'
        @ch2 = Channel.create created_by: @graph_user, title: 'foo2'
        ChannelList.new(@graph_user).channels.to_a.should =~ [@ch1,@ch2]+@expected_channels
      end
    end
    describe "after creating two channels and deleting the first" do
      it "should contain the second channel and the expected channels" do
        @ch1 = Channel.create created_by: @graph_user, title: 'foo'
        @ch2 = Channel.create created_by: @graph_user, title: 'foo2'
        @ch1.delete
        ChannelList.new(@graph_user).channels.to_a.should =~ [@ch2]+@expected_channels
      end
    end
    describe "after creating a channel, and someone else creates a channel" do
      it "only contains our channel, and the expected channels" do
        @ch1 = Channel.create created_by: @graph_user, title: 'foo'
        @ch2 = Channel.create created_by: (create :graph_user), title: 'foo2'

        ChannelList.new(@graph_user).channels.to_a.should =~ [@ch1]+@expected_channels
      end
    end
  end

  describe 'get_by_topic_slug' do
    it "returns nil if the list does not contain said channel" do
      ch = ChannelList.new(@graph_user).get_by_slug_title 'henk'
      expect(ch).to be_nil
    end
    it "returns one channel by topic slug" do
      @ch1 = Channel.create created_by: @graph_user, title: 'foo'
      ch = ChannelList.new(@graph_user).get_by_slug_title 'foo'
      expect(ch).to eq @ch1
    end
  end

  describe ".sorted_channels" do
    it "should return the channels" do
      gu1 = create :graph_user
      ch1 = create :channel, created_by: gu1, title: 'a'
      ch2 = create :channel, created_by: gu1, title: 'b'
      ch3 = create :channel, created_by: gu1, title: 'c'

      list = ChannelList.new(gu1)

      expect(list.sorted_channels.map(&:title)).
        to eq ['a', 'All', 'b', 'c', 'Created']
    end
  end

  describe '.containing_channel_ids' do
    include Pavlov::Helpers
    let(:current_user) {create :graph_user}
    def pavlov_options
      {current_user: current_user}
    end
    it "returns the channels of the graphuser which contain the fact" do
      gu1 = current_user.graph_user

      ch1 = create :channel, created_by: gu1, title: 'a'
      ch2 = create :channel, created_by: gu1, title: 'b'
      ch3 = create :channel, created_by: gu1, title: 'c'

      f = create :fact

      interactor :"channels/add_fact", f, ch1
      interactor :"channels/add_fact", f, ch3

      list = ChannelList.new(gu1)

      expect(list.containing_channel_ids_for_fact(f)).
        to eq [gu1.stream_id, ch1.id, ch3.id]

    end
  end

  describe ".containing_channel_ids_for_channel" do
    subject {ChannelList.new(u1)}
    let(:ch) {Channel.create(:created_by => u1, :title => "Subject")}

    let(:u1_ch1) {Channel.create(:created_by => u1, :title => "Something")}
    let(:u2_ch1) {Channel.create(:created_by => u2, :title => "Something")}

    let(:u1) { create :graph_user }
    let(:u2) { create :graph_user }

    describe "initially" do
      it "is empty" do
        subject.containing_channel_ids_for_channel(ch).to_a.should =~ []
      end
    end
    describe "after adding to a own channel" do
      it "contains the channel" do
        u1_ch1.add_channel ch
        subject.containing_channel_ids_for_channel(ch).to_a.should =~ [u1_ch1.id]
      end
    end
    describe "after adding to someone else's channel" do
      it "contains only my channels" do
        u1_ch1.add_channel ch
        u2_ch1.add_channel ch

        subject.containing_channel_ids_for_channel(ch).to_a.should =~ [u1_ch1.id]
      end
    end
  end

end
