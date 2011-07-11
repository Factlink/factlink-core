require 'spec_helper'

describe FactRelation do

  before(:each) do
    @parent = Fact.new
    @evidence1 = Fact.new
    @evidence2 = Fact.new
    
    @parent.save
    @evidence1.save
    @evidence2.save
    
    @user1 = User.new(:username => "tomdev")
    @user2 = User.new(:username => "zamboya")
    
    @user1.save
    @user2.save
    
    @fr = @parent.add_evidence(:supporting, @evidence1, @user1)
  end


  it "should return a FactRelation when adding evidence" do
    @fr.should be_an_instance_of(FactRelation)
  end

  it "should have a percentage of 0 when new" do
    @fr.percentage.should == 0
  end

  

end