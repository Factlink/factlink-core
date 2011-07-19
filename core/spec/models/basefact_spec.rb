require 'spec_helper'

def others(opinion)
  others = [:beliefs, :doubts, :disbeliefs]
  others.delete(opinion)
  others
end

describe Basefact do

  let(:user) {FactoryGirl.create(:user)}
  let(:user2) {FactoryGirl.create(:user)}

  let(:fact2) {FactoryGirl.create(:fact)}

  before do
    @facts = FactoryGirl.create_list(:fact,1)
    @users = FactoryGirl.create_list(:user,2)
  end

  context "initially" do
    its(:interacting_users) {should be_empty }
    [:beliefs, :doubts, :disbeliefs].each do |opinion|
      it { subject.opiniated_count(opinion).should == 0 }
    end
  end

  @opinions = [:beliefs, :doubts, :disbeliefs]
  @opinions.each do |opinion|

    describe "#add_opinion" do
      context "after 1 person has stated its #{opinion}" do
        before do
          subject.add_opinion(opinion, user)
        end
        it { subject.opiniated_count(opinion).should == 1 }
        its(:interacting_users) {should =~ [user]}
      end


      context "after 1 person has stated its #{opinion}" do
        before do
          subject.add_opinion(opinion, user)
        end
        it { subject.opiniated_count(opinion).should == 1 }
        its(:interacting_users) {should =~ [user]}
      end

      context "after 1 person has stated its #{opinion} twice" do
        before do
          subject.add_opinion(opinion, user)
          subject.add_opinion(opinion, user)
        end
        it {subject.opiniated_count(opinion).should == 1}
        its(:interacting_users) {should =~ [user]}
      end
    end

    describe "#toggle_opinion" do
      context "after one toggle on #{opinion}" do
        before do
          subject.toggle_opinion(opinion,user)
        end
        it { subject.opiniated_count(opinion).should==1 }
        its(:interacting_users) {should =~ [user]}
      end

      context "two toggles on #{opinion} by the same user" do
        before do
          subject.toggle_opinion(opinion,user)
          subject.toggle_opinion(opinion,user)
        end
        it { subject.opiniated_count(opinion).should == 0 }
        its(:interacting_users) {should be_empty}
      end

      it "should change opiniated_count to 2 after two toggles by the different users on the same fact" do
        subject.toggle_opinion(opinion,user)
        subject.toggle_opinion(opinion,user2)
        subject.opiniated_count(opinion).should == 2
      end

      it "should change opiniated_count to 1 (twice) after two toggles by the same user on different facts" do
        subject.toggle_opinion(opinion,user)
        fact2.toggle_opinion(opinion,user)
        subject.opiniated_count(opinion).should == 1
        fact2.opiniated_count(opinion).should == 1
      end

      it "should change opiniated_count to 1 after toggling with different opinions" do
        subject.toggle_opinion(opinion           ,user)
        subject.toggle_opinion(others(opinion)[0],user)
        subject.opiniated_count(opinion).should==0
        subject.opiniated_count(others(opinion)[0]).should==1
      end
    end

    context "after one interaction" do
      before {subject.toggle_opinion(opinion,user)}
    end
    #context "after one belief and one change of mind"do

    #its(:interacting_users) "should still contain the user once"
    #end

    describe "#interacting_users" do
      it "should be 1 after 1 interactian"
      it "should be one after 1 belief and one change of mind"
      it "should be two after two users have the same opinion"
      it "should be zero after two toggles"
    end

    it "should have 0 believers when one believer is added and deleted" do
      subject.add_opinion(opinion, user)
      subject.remove_opinions user
      subject.opiniated_count(opinion).should == 0
    end

    it "should have 2 believer when two believers are added" do
      subject.add_opinion(opinion, user)
      subject.add_opinion(opinion, user2)
      subject.opiniated_count(opinion).should == 2
    end

    others(opinion).each do |other_opinion|
      it "should have 1 believer when a existing believer changes its opinion to 'doubt'" do
        subject.add_opinion(opinion, user)
        subject.add_opinion(opinion, user2)
        subject.add_opinion(other_opinion, user)
        subject.opiniated_count(opinion).should == 1
      end

      it "should have 0 believers when both existing believers change their opinion to 'doubt'" do
        subject.add_opinion(opinion, user)
        subject.add_opinion(opinion, user2)
        subject.add_opinion(other_opinion, user)
        subject.add_opinion(other_opinion, user2)
        subject.opiniated_count(opinion).should == 0
      end

      it "should have 1 believers when a existing believer changes its opinion to 'disbelieve'" do
        subject.add_opinion(opinion, user)
        subject.add_opinion(opinion, user2)
        subject.add_opinion(other_opinion, user)
        subject.opiniated_count(opinion).should == 1
      end
    end

  end  

  f = Fact.new(:displaystring=>"foo")

  describe "Mongoid properties should work" do
    [:displaystring, :title, :passage, :content].each do |attr|
      subject {Basefact.new()}
      it "#{attr} should be changeable" do
        subject.send "#{attr}=" , "quux"
        subject.send("#{attr}").should == "quux"
      end
    end
  end

  describe "#to_s" do
    before(:each) do
      @with_s = Basefact.new()
    end
    it "should work without init" do
      @with_s.to_s.should be_a(String)
    end
    it "should work with initialisation" do
      @with_s.displaystring = "hiephoipiepeloi"
      @with_s.to_s.should == "hiephoipiepeloi"
    end
  end
end