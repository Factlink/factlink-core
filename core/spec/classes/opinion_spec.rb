require 'spec_helper'

describe Opinion do

  before(:each) do
    @parent = Fact.new
    @factlink = Fact.new
    @factlink2 = Fact.new
    
    @user1 = User.new(:username => "tomdev")
    @user2 = User.new(:username => "zamboya")
  end
  
  it "Belief should be 1 after setting it to 1" do
    Opinion.new(1,0,0,1).b.should == 1
  end
end