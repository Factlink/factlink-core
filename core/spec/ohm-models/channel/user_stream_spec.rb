require 'spec_helper'

describe Channel::UserStream do
  include AddFactToChannelSupport
  subject(:stream) { u1.stream }

  let(:u1) { FactoryGirl.create(:user).graph_user }

  describe "initially" do
    it { stream.facts.to_a.should =~ []}
    its(:is_real_channel?) { should == false }
    its(:title) {should == "All" }
    its(:unread_count) {should == 0 }
    its(:contained_channels) {should == [u1.created_facts_channel]}
  end

  describe "after adding one empty channel" do
    before do
      @ch1 = create(:channel, :created_by => u1)
    end
    it { stream.facts.to_a.should =~ []}
  end

  describe "after creating a fact" do
    before do
      @f1 = create(:fact, :created_by => u1)
    end
    it { stream.facts.to_a.should =~ []}
  end

  describe "after adding channel with one fact" do
    before do
      @ch1 = create(:channel, :created_by => u1)
      @f1 = create(:fact)
      add_fact_to_channel @f1, @ch1
    end
    it { stream.facts.to_a.should =~ []}
    its(:unread_count) {should == 0 }
    describe "after retrieving the user_stream from the database" do
      it {GraphUser[stream.id].stream.facts.to_a.should =~[]}
    end
  end
  describe "after adding two channels with one fact" do
    before do
      @ch1 = create(:channel, :created_by => u1)
      @f1 = create(:fact)
      add_fact_to_channel @f1, @ch1
      @ch2 = create(:channel, :created_by => u1)
      @f2 = create(:fact)
      add_fact_to_channel @f2, @ch2
    end
    it { stream.facts.to_a.should == []}
    its(:unread_count) {should == 0 }
    describe "after creating a fact" do
      before do
        @f3 = create(:fact, :created_by => u1)
      end
      it { stream.facts.to_a.should == []}
    end
    describe "after creating a factrelation" do
      before do
        @fr = FactRelation.get_or_create(@f1,:supporting,@f2,u1)
      end
      it { stream.facts.to_a.should == []}
      its(:unread_count) {should == 0 }
    end

  end

  describe :topic do
    it "should be nil" do
      stream.topic.should be_nil
    end
    it "should be nil, and not crash when slugtitle is not set" do
      stream.slug_title = nil
      stream.topic.should be_nil
    end
  end
end
