require 'spec_helper'
require "cancan/matchers"

describe Ability do

  #abilities
  subject {Ability.new(user)}
  let(:anonymous) {Ability.new}
  let(:admin) { Ability.new admin_user}
  let(:nonnda) { Ability.new nonnda_user}

  #users used as object
  let(:user) {FactoryGirl.create :user}
  let(:other_user) {FactoryGirl.create :user}
  let(:admin_user) {FactoryGirl.create :user, admin: true}
  let(:nonnda_user) {FactoryGirl.create :user, agrees_tos: false}

  describe "to manage a user" do
    context "as a normal user" do
      it {subject.should_not be_able_to :manage, User }

      it {subject.should     be_able_to :show, user }
      it {subject.should     be_able_to :update, user }
      it {subject.should_not be_able_to :sign_tos, user }
      it {subject.should_not be_able_to :update, other_user }
      it {subject.should_not be_able_to :update, admin }
    end
    context "as a nonnda user" do
      it {nonnda.should_not be_able_to :manage, User }

      it {nonnda.should_not be_able_to :update, nonnda_user }
      it {nonnda.should     be_able_to :sign_tos, nonnda_user }
      it {nonnda.should     be_able_to :show, nonnda_user }
      it {nonnda.should_not be_able_to :show, User }
    end
    context "as an admin" do
      it {admin.should     be_able_to :manage, User }
      it {admin.should_not be_able_to :sign_tos, user }
      it {admin.should_not be_able_to :sign_tos, admin_user }
    end
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
      it {subject.should_not  be_able_to :update, ch2 }
      it {subject.should      be_able_to :read, ch2 }
      it {subject.should_not  be_able_to :create, ch2 }
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
      it {subject.should_not  be_able_to :update, f2 }
      it {subject.should      be_able_to :read, f2 }
      it {subject.should      be_able_to :opinionate, f2 }
      it {subject.should      be_able_to :add_evidence, f2 }
      it {subject.should_not  be_able_to :create, f2 }
    end

    describe "without logging in" do
      it {anonymous.should      be_able_to :index, Fact }
      it {anonymous.should_not  be_able_to :create, Fact }
      it {anonymous.should_not  be_able_to :opinionate, Fact }
      it {anonymous.should_not  be_able_to :add_evidence, f1 }
      it {anonymous.should      be_able_to :read, f1 }
    end
  end

  describe "managing jobs" do
    describe "as anonymous" do
      it {anonymous.should      be_able_to :read, Job}
      it {anonymous.should_not  be_able_to :manage, Job}
    end
    describe "as a user" do
      it {subject.should        be_able_to :read, Job}
      it {subject.should_not    be_able_to :manage, Job}
    end
    describe "as an admin" do
      it {admin.should          be_able_to :manage, Job}
    end
  end

  describe "accessing the admin area" do
    it "should only be allowed as admin" do
      admin.should         be_able_to :access, Ability::AdminArea
      subject.should_not   be_able_to :access, Ability::AdminArea
      anonymous.should_not be_able_to :access, Ability::AdminArea
    end
  end

  describe "accessing factlink" do
    it "should be allowed to users who signed the nda" do
      admin.should           be_able_to :access, Ability::FactlinkWebapp
      subject.should         be_able_to :access, Ability::FactlinkWebapp
      anonymous.should_not   be_able_to :access, Ability::FactlinkWebapp
      nonnda.should_not      be_able_to :access, Ability::FactlinkWebapp
    end
  end

  describe "listing jobs" do
    before do
      @j1 = FactoryGirl.create :job, show: true
      @j2 = FactoryGirl.create :job, show: false
      @j3 = FactoryGirl.create :job, show: true
    end

    it "should list all jobs for admin" do
      Job.accessible_by(admin).to_a.should =~ [@j1, @j2, @j3]
    end

    it "should list two jobs for non-admin user" do
      Job.accessible_by(subject).to_a.should =~ [@j1, @j3]
    end

    it "should list two jobs for anonymous user" do
      Job.accessible_by(anonymous).to_a.should =~ [@j1, @j3]
    end
  end
end