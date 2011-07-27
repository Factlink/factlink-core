require File.expand_path("../../spec_helper.rb", __FILE__)
#require 'spec_helper'

describe FactRelation do

  before(:each) do
    @parent = FactoryGirl.create(:fact)
    @evidence = FactoryGirl.create_list(:fact,2)
    @users = FactoryGirl.create_list(:user,2)
  end

  context "initially" do
    
  end



  describe "percentages should work logical" do
    it "should have a percentage of 0 when new" do
      pending
      @fr.percentage.should == 0
    end

  end

  describe "#get_or_create" do
    it "should return a new factrelation when the relation does not exist" do
      @fact1 =FactoryGirl.create(:fact)
      @fact2 =FactoryGirl.create(:fact)
      @fr = FactRelation.get_or_create(@fact1,:supporting,@fact2,@users[0])
      @fr.should be_a(FactRelation)
    end

    it "should find the relation when the relation does exist" do
      @fact1 =FactoryGirl.create(:fact)
      @fact2 =FactoryGirl.create(:fact)
      @fr = FactRelation.get_or_create(@fact1,:supporting,@fact2,@users[0])
      @fr.should be_a(FactRelation)
      @fr2 = FactRelation.get_or_create(@fact1,:supporting,@fact2,@users[0])
      @fr2.should be_a(FactRelation)
      @fr3 = FactRelation.get_or_create(@fact1,:supporting,@fact2,@users[0])
      @fr3.should be_a(FactRelation)
      @fr.should == @fr2
      @fr2.should == @fr3
    end
    
    it "should return a new object after the object was deleted"
  end

  it "should delete itself from lists referring to it"
  
end