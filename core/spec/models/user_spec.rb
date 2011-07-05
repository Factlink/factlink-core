require 'spec_helper'

describe User do

  before(:each) do
    @parent = Fact.new
    @child1 = Fact.new
    @child2 = Fact.new

    @user1 = User.new(:username => "tomdev")
    @user2 = User.new(:username => "zamboya")
    
    @parent.add_child_as_supporting @child1, @user1
    @parent.add_child_as_supporting @child2, @user2
  end

  it "should have two childs" do
    @parent.childs_count.should == 2
  end

  it "should have one first child which is the first child" do
    @parent.childs.first == @child1
  end

  it "should have zero active factlinks on create" do
    @user1.active_on_factlinks.count.should == 0
  end

  it "should have one active factlink after adding believe" do
    @child1.add_opinion(:beliefs, @user1, @parent)
    @user1.active_on_factlinks.count.should == 1
  end

  it "should have a toggle value for the factlink key it voted on" do
    @child1.add_opinion(:beliefs, @user1, @parent)
    @user1.get_opinion(@child1, @parent)
  end

end
