require 'spec_helper'
def b(user,fact)
  fact.add_opinion(:beliefs,user)
end

def d(user,fact)
  fact.add_opinion(:disbeliefs,user)
end

def u(user,fact)
  fact.add_opinion(:doubts,user)
end

def _(b,d,u,a)
  Opinion.new(:b=>b,:d=>d,:u=>u,:a=>a)
end

def opinion?(fact)
  fact.get_opinion.should
end

describe "beliefs should work as described in the google doc" do


  let(:u1) {FactoryGirl.create(:user)}
  let(:u2) {FactoryGirl.create(:user)}
  let(:u3) {FactoryGirl.create(:user)}
  let(:u4) {FactoryGirl.create(:user)}

  let(:f1) {FactoryGirl.create(:fact)}
  let(:f2) {FactoryGirl.create(:fact)}

  # f1 --> f2
  let(:f22) { f2.add_evidence(:supporting,f1,u1) }
  
  # f1 !-> f2
  let(:f23) { f2.add_evidence(:weakening,f1,u1) }

  it "scenario 0" do
    opinion?(f1) == _(0.0,0.0,1.0,0.0)
  end

  it "scenario 1" do
    b(u1,f1)
    b(u2,f1)
    opinion?(f1) == _(1.0,0.0,0.0,2.0)
  end

  it "scenario 2" do
    b(u1,f1)
    d(u2,f1)
    opinion?(f1) == _(0.5,0.5,0.0,2.0)
  end

  it "scenario 3" do
    b(u1,f1)
    u(u2,f1)
    opinion?(f1) == _(0.5,0.0,0.5,2.0)
  end

  it "scenario 4" do
    b(u1,f1)
    b(u2,f1)
    b(u2,f22)
    opinion?(f22) == _(1.0,0.0,0.0,1.0)
    opinion?(f2) == _(1.0,0.0,0.0,1.0)
  end

  it "scenario 5" do
    b(u1,f1)
    b(u2,f1)
    b(u2,f23)
    opinion?(f23) == _(1.0,0.0,0.0,1.0)
    opinion?(f2) == _(0.0,1.0,0.0,1.0)
  end
  
  it "scenario 6" do
    b(u1,f1)
    b(u2,f1)
    b(u1,f22)
    d(u2,f22)
    opinion?(f22) == _(0.5,0.5,0.0,2.0)
    opinion?(f2) == _(0.5,0.0,0.5,2.0)
  end
  
  it "scenario 7" do
    b(u1,f1)
    d(u2,f1)
    b(u1,f22)
    opinion?(f1) == _(0.5,0.5,0.0,2.0)
    opinion?(f22) == _(1.0,0.0,0.0,1.0)
    opinion?(f2) == _(0.5,0.0,0.5,1.0)
  end
  
  it "scenario 8" do
    b(u1,f1)
    b(u2,f1)
    b(u1,f22)
    d(u3,f2)
    opinion?(f1) == _(1.0,0.0,0.0,2.0)
    opinion?(f22) == _(1.0,0.0,0.0,1.0)
    opinion?(f2) == _(0.5,0.5,0.0,2.0)
  end
end
