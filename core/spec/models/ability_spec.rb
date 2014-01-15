require 'spec_helper'
require "cancan/matchers"

describe Ability do

  # abilities
  subject                { Ability.new(user) }
  let(:anonymous)        { Ability.new }
  let(:admin)            { Ability.new admin_user }
  let(:non_set_up)       { Ability.new non_set_up_user }

  # users used as object
  let(:user)        { create :full_user }
  let(:other_user)  { create :full_user }
  let(:admin_user)  { create :full_user, :admin }
  let(:non_set_up_user) { create :user, set_up: false }

  let(:deleted_user) { create :full_user, deleted: true }

  describe "to manage a user" do
    context "as a normal user" do
      it { subject.should_not be_able_to :manage, User }
      it { subject.should_not be_able_to :configure, Ability::FactlinkWebapp }

      it { subject.should     be_able_to :show, user }
      it { subject.should     be_able_to :show, other_user }
      it { subject.should     be_able_to :update, user }
      it { subject.should     be_able_to :destroy, user }

      it { subject.should     be_able_to :edit_settings, user }
      it { subject.should     be_able_to :set_up, user }

      it { subject.should_not be_able_to :update, other_user }
      it { subject.should_not be_able_to :update, admin }
      it { subject.should_not be_able_to :destroy, other_user }

      it { subject.should be_able_to :show, deleted_user }
    end
    context "as a non set up user" do
      it { non_set_up.should_not be_able_to :manage, User }

      it { non_set_up.should_not be_able_to :update, non_set_up_user }
      it { non_set_up.should     be_able_to :set_up, non_set_up_user }
      it { non_set_up.should     be_able_to :show, non_set_up_user }
      it { non_set_up.should     be_able_to :show, User }
    end
    context "as an admin" do
      it { admin.should     be_able_to :manage, User }
      it { admin.should     be_able_to :configure, Ability::FactlinkWebapp }

      it { admin.should_not be_able_to :edit_settings, user }
      it { admin.should be_able_to     :edit_settings, admin_user }

      it { admin.should     be_able_to :set_up, user }
      it { admin.should     be_able_to :set_up, admin_user }
    end
    context "as an anonymous" do
      it { anonymous.should_not be_able_to :manage, User }

      it { anonymous.should_not be_able_to :set_up, user }
      it { anonymous.should     be_able_to :show, User }
      it { anonymous.should_not be_able_to :edit_settings, user }
    end
  end

  describe "to get the fact count of a site" do
    context "as any user" do
      it { subject.should   be_able_to :get_fact_count, Site }
      it { anonymous.should be_able_to :get_fact_count, Site }
    end
  end

  describe "to manage channels" do

    let(:ch1) { create :channel, created_by: user.graph_user }
    let(:ch2) { create :channel, created_by: other_user.graph_user }

    it { subject.should be_able_to :index, Channel }
    it { subject.should be_able_to :create, Channel }

    describe "of my own" do
      it { subject.should be_able_to :update, ch1 }
      it { subject.should be_able_to :read, ch1 }
      it { subject.should be_able_to :create, ch1 }
    end

    describe "of someone else" do
      it { subject.should_not  be_able_to :update, ch2 }
      it { subject.should      be_able_to :read, ch2 }
      it { subject.should_not  be_able_to :create, ch2 }
    end

    describe "without logging in" do
      it { anonymous.should     be_able_to :index, Channel }
      it { anonymous.should     be_able_to :read, ch1 }
      it { anonymous.should_not be_able_to :create, Channel }
      it { anonymous.should_not be_able_to :update, ch1 }
      it { anonymous.should_not be_able_to :create, ch1 }
    end
  end

  describe "to manage facts" do
    let(:f1) { create :fact, created_by: user.graph_user }
    let(:f2) { create :fact, created_by: other_user.graph_user }

    it { subject.should be_able_to :index, Fact }
    it { subject.should be_able_to :create, Fact }

    describe "of my own" do
      it { subject.should_not be_able_to :update, f1 }
      it { subject.should     be_able_to :read, f1 }
      it { subject.should     be_able_to :opinionate, f1 }
      it { subject.should     be_able_to :add_evidence, f1 }
      it { subject.should     be_able_to :create, f1 }
      it { subject.should     be_able_to :share, f1 }
    end

    describe "of someone else" do
      it { subject.should_not  be_able_to :update, f2 }
      it { subject.should      be_able_to :read, f2 }
      it { subject.should      be_able_to :opinionate, f2 }
      it { subject.should_not  be_able_to :create, f2 }
      it { subject.should      be_able_to :share, f2 }
    end

    describe "without logging in" do
      it { anonymous.should      be_able_to :index, Fact }
      it { anonymous.should      be_able_to :read, f1 }

      it { anonymous.should_not  be_able_to :create, Fact }
      it { anonymous.should_not  be_able_to :update, f1 }
      it { anonymous.should_not  be_able_to :opinionate, Fact }
      it { anonymous.should_not  be_able_to :add_evidence, f1 }
      it { anonymous.should_not  be_able_to :share, f1 }
    end
  end

  describe "to manage Comments" do
    let(:c1) { create :comment, created_by: user }
    let(:c2) { create :comment, created_by: other_user }

    describe "of my own" do
      it { subject.should be_able_to :read, c1 }
      it { subject.should be_able_to :destroy, c1 }
    end

    describe "of someone else" do
      it { subject.should     be_able_to :read, c2 }
      it { subject.should_not be_able_to :destroy, c2 }
    end

    describe "without logging in" do
      it { anonymous.should     be_able_to :read, c1 }
      it { anonymous.should_not be_able_to :destroy, c1 }
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
    it "should be allowed to signed in, set up users" do
      admin.should           be_able_to :access, Ability::FactlinkWebapp
      subject.should         be_able_to :access, Ability::FactlinkWebapp
      non_set_up.should_not  be_able_to :access, Ability::FactlinkWebapp
      anonymous.should_not   be_able_to :access, Ability::FactlinkWebapp
    end
  end

  describe "seeing notifications" do
    it "should be possible to see and modify your own notifications" do
      subject.should be_able_to :see_activities, user
      subject.should be_able_to :mark_activities_as_read, user
    end

    it "should not be able to see and modify other people their notifications" do
      subject.should_not be_able_to :see_activities, other_user
      subject.should_not be_able_to :mark_activities_as_read, other_user
    end
  end

  describe "topics" do
    let(:topic) { create :topic }
    it "should be able to view a topic" do
      subject.should be_able_to :show, topic
      anonymous.should be_able_to :show, topic
    end
  end

  describe "sharing" do
    it "should not be allowed by default" do
      admin.should_not     be_able_to :share_to, admin_user.social_account('twitter')
      subject.should_not   be_able_to :share_to, user.social_account('twitter')
      admin.should_not     be_able_to :share_to, admin_user.social_account('facebook')
      subject.should_not   be_able_to :share_to, user.social_account('facebook')
    end

    context "when connected to Twitter" do
      it "should be possible to share to Twitter" do
        create :social_account, :twitter, user: user

        Ability.new(user).should be_able_to :share_to, user.social_account('twitter')
      end
    end

    context "when connected to Facebook" do
      it "should be possible to share to Facebook" do
        create :social_account, :facebook, user: user

        Ability.new(user).should be_able_to :share_to, user.social_account('facebook')
      end
    end
  end

end
