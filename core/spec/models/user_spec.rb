require 'spec_helper'

describe User do

  subject {FactoryGirl.create :user}

  let(:fact) {FactoryGirl.create :fact}
  let(:child1) {FactoryGirl.create :fact}

  context "Initially" do
    it {subject.graph_user.facts.to_a.should == []}
    it {subject.graph_user.should == subject.graph_user }
    it "should not be an Admin" do
      subject.admin.should == false
    end
  end

  it "should have one active factlink after adding believe" do
    child1.add_opinion(:beliefs, subject.graph_user)
    subject.graph_user.facts.size == 1
  end

  it "should have a GraphUser" do
    subject.graph_user.should be_a(GraphUser)
  end

  [:beliefs,:doubts,:disbeliefs].each do |type|
    it "should store the Fact ID in the graph_user object when a user #{type} a fact" do
      fact.add_opinion(type, subject.graph_user )
      subject.graph_user.has_opinion?(type,fact).should == true
    end
  end
end
