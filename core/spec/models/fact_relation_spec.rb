require 'spec_helper'

describe FactRelation do

  before(:each) do
    @parent = Fact.new
    @evidence1 = Fact.new
    @evidence2 = Fact.new
    
    @parent.save
    @evidence1.save
    @evidence2.save

    @users = FactoryGirl.create_list(:user,2)
    
    @fr = @parent.add_evidence(:supporting, @evidence1, @users[1])
  end


  it "should return a FactRelation when adding evidence" do
    @fr.should be_an_instance_of(FactRelation)
  end

  it "should have a percentage of 0 when new" do
    @fr.percentage.should == 0
  end

  

end