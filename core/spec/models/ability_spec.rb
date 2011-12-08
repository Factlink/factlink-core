require 'spec_helper'
require "cancan/matchers"

describe Ability do
  
  subject {Ability.new(user)}
  let(:anonymous) {Ability.new}

  let(:user) {FactoryGirl.create :user}
  let(:other_user) {FactoryGirl.create :user}

  let(:admin) { FactoryGirl.create :user, admin: true }
  let(:admin_ability) { Ability.new(admin) }
  
  describe "to managing myself" do
    it {subject.should be_able_to :update, user }
    it {subject.should_not be_able_to :update, other_user }
    it {subject.should_not be_able_to :update, admin }
  end

  describe ", as Admin, to manage a user" do
    it {admin_ability.should be_able_to :manage, User }
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

    describe "without logging in" do
      it {anonymous.should_not be_able_to :index, Channel }
      it {anonymous.should_not be_able_to :create, Channel }
      it {anonymous.should_not be_able_to :read, ch1 }
      it {anonymous.should_not be_able_to :update, ch1 }
      it {anonymous.should_not be_able_to :create, ch1 }
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
      it {subject.should be_able_to :opinionate, f1 }
      it {subject.should be_able_to :add_evidence, f1 }
      it {subject.should be_able_to :create, f1 }
    end

    describe "of someone else" do
      it {subject.should_not be_able_to :update, f2 }
      it {subject.should be_able_to :read, f2 }
      it {subject.should be_able_to :opinionate, f2 }
      it {subject.should be_able_to :add_evidence, f2 }
      it {subject.should_not be_able_to :create, f2 }
    end
   
    describe "without logging in" do
      it {anonymous.should be_able_to :index, Fact }
      it {anonymous.should_not be_able_to :create, Fact }
      it {anonymous.should_not be_able_to :opinionate, Fact }
      it {anonymous.should_not be_able_to :add_evidence, f1 }
      it {anonymous.should be_able_to :read, f1 }
    end
  end
end