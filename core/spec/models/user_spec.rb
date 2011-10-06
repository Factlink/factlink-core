require 'spec_helper'

describe User do

  subject {FactoryGirl.create(:user)}

  before(:each) do
    @parent = FactoryGirl.create(:fact)
    @child1 = FactoryGirl.create(:fact)
    @child2 = FactoryGirl.create(:fact)

    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)

    @factlink = FactoryGirl.create(:fact)
    @factlink2 = FactoryGirl.create(:fact)
  end
  context "Initially" do
    it {subject.graph_user.facts.to_a.should == []}
    it {subject.graph_user.should == subject.graph_user }
  end

  it "should have one active factlink after adding believe" do
    @child1.add_opinion(:beliefs, @user1.graph_user)
    @user1.graph_user.facts.size == 1
  end

  it "should have a GraphUser" do
    @user1.graph_user.should be_a(GraphUser)
  end

  [:beliefs,:doubts,:disbeliefs].each do |type|
    it "should store the Fact ID in the graph_user object when a user #{type} a fact" do
      @factlink.add_opinion(type, @user1.graph_user )
      @user1.graph_user.has_opinion?(type,@factlink).should == true
    end
  end
end
