require 'spec_helper'

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
end