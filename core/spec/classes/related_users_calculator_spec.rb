require 'spec_helper'

class TestUser
end

class TestFact
  def initiate
    @list = []
  end
  def add_opiniated(type, user)
    @list << user
  end
  def interacting_users
    return @list
  end
end

describe RelatedUsersCalculator do
  let(:u1) { FactoryGirl.create(:user).graph_user }
  let(:u2) { FactoryGirl.create(:user).graph_user }
  let(:u3) { FactoryGirl.create(:user).graph_user }

  let (:f1) {FactoryGirl.create(:fact) }
  let (:f2) {FactoryGirl.create(:fact) }
  let (:f3) {FactoryGirl.create(:fact) }
  let (:f4) {FactoryGirl.create(:fact) }
  let (:f5) {FactoryGirl.create(:fact) }

  
  before do
    f1.add_opiniated(:believes, u1)
    f2.add_opiniated(:believes, u2)
    f3.add_opiniated(:believes, u1)
  end
  it "should work for an empty list " do
    subject.related_users([]).to_a.should =~ []
  end
  
  it "should work for a list with one facts" do
    subject.related_users([f1]).to_a.should =~ [u1]
  end
  it "should work for a list with multiple facts" do
    subject.related_users([f1,f2]).to_a.should =~ [u1,u2]
  end
  it "should work for a list of facts with overlapping interacting users" do
    subject.related_users([f1,f2,f3]).to_a.should =~ [u1,u2]
  end
  it "should work with a list of facts without interacting users" do
    subject.related_users([f4,f5]).to_a.should =~ []
  end
  it "should work with a list of facts without interacting users and with " do
    subject.related_users([f1,f5]).to_a.should =~ [u1]
    subject.related_users([f5,f1]).to_a.should =~ [u1]
  end
  describe "after giving a certain user more authority" do
    before do
      f4.add_opiniated(:believes, u3)
      u3.cached_authority = 13
      u3.save
    end
    it "should have the right ordering" do
      subject.related_users([f1,f4]).to_a.should == [u3,u1]
      subject.related_users([f4,f1]).to_a.should == [u3,u1]
    end
  end
    
  describe "without parameter" do
    before do 
      f1.add_opiniated(:believes, u1)
      f2.add_opiniated(:believes, u2)
      f3.add_opiniated(:believes, u1)
    end

    it "should work" do
      subject.related_users([f1,f2,f3],:without=>[u1]).should =~ [u2]
    end
  end
end