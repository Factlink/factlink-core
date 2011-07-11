require 'spec_helper'

describe FactRelation do

  before(:each) do
    @parent = FactoryGirl.create(:fact)
    @evidence = FactoryGirl.create_list(:fact,2)
    @users = FactoryGirl.create_list(:user,2)
    
    @fr = @parent.add_evidence(:supporting, @evidence[1], @users[1])
  end


  it "should return a FactRelation when adding evidence" do
    @fr.should be_an_instance_of(FactRelation)
  end

  it "should have a percentage of 0 when new" do
    @fr.percentage.should == 0
  end

  

end