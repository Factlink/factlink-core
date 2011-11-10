require File.expand_path("../../spec_helper.rb", __FILE__)
#require 'spec_helper'

describe FactRelation do

  before(:each) do
    @parent = FactoryGirl.create(:fact)
    @evidence = FactoryGirl.create_list(:fact,2)
    @users = FactoryGirl.create_list(:user,2)
  end


  describe "#get_or_create" do
    it "should return a new factrelation when the relation does not exist" do
      @fact1 =FactoryGirl.create(:fact)
      @fact2 =FactoryGirl.create(:fact)
      @fr = FactRelation.get_or_create(@fact1, :supporting, @fact2, @users[0])
      @fr.should be_a(FactRelation)
    end
    
    it "should have a created_by GraphUser when created" do
      @fr = FactRelation.get_or_create(@evidence[0], :supporting, @parent, @users[0])
      @fr.created_by.should be_a(GraphUser)
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
  end

  it "should add itself to the list of evidence" do
    @fact1 =FactoryGirl.create(:fact)
    @fact2 =FactoryGirl.create(:fact)
    @fr = FactRelation.get_or_create(@fact1,:supporting,@fact2,@users[0])
    @fact2.evidence(:supporting).to_a.collect{ |x| x.from_fact }.should =~ [@fact1]
  end

  it "should delete itself from lists referring to it" do
    @fact1 =FactoryGirl.create(:fact)
    @fact2 =FactoryGirl.create(:fact)
    @fr = FactRelation.get_or_create(@fact1,:supporting,@fact2,@users[0])
    @fact1.delete
    @fact2.evidence(:supporting).size.should == 0
  end
  
end