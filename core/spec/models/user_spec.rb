require 'spec_helper'

describe User do

  subject {FactoryGirl.create :user}
  let(:nonnda_subject) {FactoryGirl.create :user, agrees_tos: false, name:'Klaas'}

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

  describe :to_param do
    it {subject.to_param.should == subject.username }
  end
  
  context "when agreeing the tos" do
    describe "when trying to agree without signing, without a name" do
      it "should not be allowed" do
        nonnda_subject.sign_tos(false, '').should == false
        nonnda_subject.errors.full_messages.length.should == 2
        nonnda_subject.name.should == 'Klaas'
        nonnda_subject.agrees_tos.should == false
      end
    end

    describe "when trying to agree without signing" do
      it "should not be allowed" do
        nonnda_subject.sign_tos(false, 'Sjaak').should == false
        nonnda_subject.errors.keys.length.should == 1
        nonnda_subject.name.should == 'Klaas'
        nonnda_subject.agrees_tos.should == false
      end
    end
    describe "when trying to agree without a name" do
      it "should not be allowed" do
        nonnda_subject.sign_tos(true, '').should == false
        nonnda_subject.errors.keys.length.should == 1
        nonnda_subject.name.should == 'Klaas'
        nonnda_subject.agrees_tos.should == false
      end
    end
    describe "when agreeing with a name" do
      it "should be allowed" do
        nonnda_subject.sign_tos(true, 'Sjaak').should == true
        nonnda_subject.name.should == 'Sjaak'
        nonnda_subject.agrees_tos.should == true
        nonnda_subject.errors.keys.length.should == 0
      end
    end
  end
  
  describe ".find" do
    it "should work with numerical ids" do
      User.find(subject.id).should == subject
    end
    it "should work with usernames" do
      User.find(subject.username).should == subject
    end
  end
end
