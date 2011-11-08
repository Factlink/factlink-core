require 'spec_helper'

describe Channel::UserStream do
  subject { u1.stream }

  let(:u1) { FactoryGirl.create(:user).graph_user }

  describe "initially" do
    it {1.should == 2}
    
    it { subject.facts.to_a.should =~ []}
    its(:discontinued) {should == false}
    its(:editable?) {should == false}
    its(:followable?) {should == false}
    its(:title) {should == "All" }
    its(:description) {should == "All facts" }
    its(:unread_count) {should == 0 }
  end  

  describe "after adding one empty channel" do
    before do
      @ch1 = create(:channel, :created_by => u1)
      Channel.recalculate_all
    end
    it { subject.facts.to_a.should =~ []}
  end
  
  describe "after creating a fact" do
    before do
      @f1 = create(:fact, :created_by => u1)
    end
    pending { subject.facts.to_a.should =~ [@f1]}
  end

  describe "after adding channel with one fact" do
    before do
      @ch1 = create(:channel, :created_by => u1)
      @f1 = create(:fact)
      @ch1.add_fact(@f1)
      Channel.recalculate_all
    end
    it { subject.facts.to_a.should =~ [@f1]}
    its(:unread_count) {should == 0 }
    describe "after retrieving the user_stream from the database" do
      it {GraphUser[subject.id].stream.facts.to_a.should =~[@f1]}
    end
  end
  describe "after adding two channels with one fact" do
    before do
      @ch1 = create(:channel, :created_by => u1)
      @f1 = create(:fact)
      @ch1.add_fact(@f1)
      @ch2 = create(:channel, :created_by => u1)
      @f2 = create(:fact)
      @ch2.add_fact(@f2)
      Channel.recalculate_all
    end
    it { subject.facts.to_a.should =~ [@f1,@f2]}
    its(:unread_count) {should == 0 }
    describe "after creating a fact" do
      before do
        @f3 = create(:fact, :created_by => u1)
      end
      pending { subject.facts.to_a.should =~ [@f1,@f2,@f3]}
    end
    describe "after creating a factrelation" do
      before do
        @fr = FactRelation.get_or_create(@f1,:supporting,@f2,u1)
      end
      it { subject.facts.to_a.should =~ [@f1,@f2]}
      its(:unread_count) {should == 0 }
    end
    
  end

end