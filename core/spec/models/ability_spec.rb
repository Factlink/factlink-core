require 'spec_helper'
require "cancan/matchers"

describe Ability do
  
  subject {Ability.new(user)}

  let(:user) {FactoryGirl.create :user}
  let(:other_user) {FactoryGirl.create :user}

  
  describe "to managing myself" do
    it {subject.should be_able_to :update, user }
    it {subject.should_not be_able_to :update, other_user }
  end

  describe "to manage channels" do

    let(:ch1) { FactoryGirl.create :channel, created_by: user.graph_user }
    let(:ch2) { FactoryGirl.create :channel, created_by: other_user.graph_user }

    it {subject.should be_able_to :index, Channel }
    it {subject.should be_able_to :create, Channel }

    describe "of my own" do
      it {subject.should be_able_to :update, ch1 }
      it {subject.should be_able_to :read, ch1 }
      it {subject.should be_able_to :create, ch1 }
    end

    describe "of someone else" do
      it {subject.should_not be_able_to :update, ch2 }
      it {subject.should be_able_to :read, ch2 }
      it {subject.should_not be_able_to :create, ch2 }
    end
  end
  
  describe "to manage facts" do
    let(:f1) { FactoryGirl.create :fact, created_by: user.graph_user }
    let(:f2) { FactoryGirl.create :fact, created_by: other_user.graph_user }
    
    it {subject.should be_able_to :index, Fact }
    it {subject.should be_able_to :create, Fact }
    
    describe "of my own" do
      it {subject.should be_able_to :update, f1 }
      it {subject.should be_able_to :read, f1 }
      it {subject.should be_able_to :create, f1 }
    end

    describe "of someone else" do
      it {subject.should_not be_able_to :update, f2 }
      it {subject.should be_able_to :read, f2 }
      it {subject.should_not be_able_to :create, f2 }
    end
    
  end
end