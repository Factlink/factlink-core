require 'spec_helper'

describe Basefact do

  before(:each) do
    @facts = FactoryGirl.create_list(:fact,1)
    @users = FactoryGirl.create_list(:user,2)
  end

  @opinions = [:beliefs, :doubts, :disbeliefs]
  @opinions.each do |opinion|
    @others = @opinions.clone
    @others.delete(opinion)

    it "should have 0 believers on new Fact when believer_count is called" do
      @facts[0].opiniated_count(opinion).should == 0
    end

    it "should have 1 believer when one believer is added" do
      @facts[0].add_opinion(opinion, @users[0])
      @facts[0].opiniated_count(opinion).should == 1
    end

    it "should have 1 believer when the same believer is added twice" do
      @facts[0].add_opinion(opinion, @users[0])
      @facts[0].add_opinion(opinion, @users[0])
      @facts[0].opiniated_count(opinion).should == 1
    end

    it "should have 0 believers when one believer is added and deleted" do
      @facts[0].add_opinion(opinion, @users[0])
      @facts[0].remove_opinions @users[0]
      @facts[0].opiniated_count(opinion).should == 0
    end

    it "should have 2 believer when two believers are added" do
      @facts[0].add_opinion(opinion, @users[0])
      @facts[0].add_opinion(opinion, @users[1])
      @facts[0].opiniated_count(opinion).should == 2
    end

    @others.each do |other_opinion|
      it "should have 1 believer when a existing believer changes its opinion to 'doubt'" do
        @facts[0].add_opinion(opinion, @users[0])
        @facts[0].add_opinion(opinion, @users[1])
        @facts[0].add_opinion(other_opinion, @users[0])
        @facts[0].opiniated_count(opinion).should == 1
      end

      it "should have 0 believers when both existing believers change their opinion to 'doubt'" do
        @facts[0].add_opinion(opinion, @users[0])
        @facts[0].add_opinion(opinion, @users[1])
        @facts[0].add_opinion(other_opinion, @users[0])
        @facts[0].add_opinion(other_opinion, @users[1])
        @facts[0].opiniated_count(opinion).should == 0
      end

      it "should have 1 believers when a existing believer changes its opinion to 'disbelieve'" do
        @facts[0].add_opinion(opinion, @users[0])
        @facts[0].add_opinion(opinion, @users[1])
        @facts[0].add_opinion(other_opinion, @users[0])
        @facts[0].opiniated_count(opinion).should == 1
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