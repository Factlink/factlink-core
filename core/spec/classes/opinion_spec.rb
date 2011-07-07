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
  
  it "Opinion should not change if you sum it with another one" do
    a = Opinion.new(1,0,0,1)
    b = Opinion.new(0,1,0,1)
    c = a + b
    a.b.should == 1
    b.d.should == 1
  end
  
end