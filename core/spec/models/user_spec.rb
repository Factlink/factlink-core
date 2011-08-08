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
    its(:facts) {should == []}
    it {subject.graph_user.should == subject.graph_user }
  end

  it "should have one active factlink after adding believe" do
    @child1.toggle_opinion(:beliefs, @user1)
    @user1.facts.size == 1
  end

  it "should have a GraphUser" do
    # @user1.graph_user.should be_a(GraphUser)
        @user1.graph_user.should be_a(GraphUser)
  end

  [:beliefs,:doubts,:disbeliefs].each do |type|
    # User should have a reference of all Fact Ids he beliefs, doubts, disbeliefs
    it "should store the Fact ID in the user object when a user #{type} a fact" do
      @factlink.toggle_opinion(type, @user1.graph_user )
      @user1.opinion_on_fact_for_type?(type,@factlink).should == true
    end
  end
end
