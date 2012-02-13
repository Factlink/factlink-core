require 'spec_helper'


describe "beliefs should work"  do
  include TopicBeliefExpressions

  let(:u1) {FactoryGirl.create(:graph_user)}
  let(:u2) {FactoryGirl.create(:graph_user)}
  let(:u3) {FactoryGirl.create(:graph_user)}
  let(:u4) {FactoryGirl.create(:graph_user)}

  before :all do
    load_topic_specific_authority
  end

  after :all do
    load_global_authority
  end


  context "for facts" do

    it "should give authority for a fact with supporting evidence" do
      f = create :fact, created_by: u1
      f2 = create :fact, created_by: u1
      f3= create :fact, created_by: u1

      f.add_evidence(:supporting,f2,u2)
      f.add_evidence(:supporting,f3,u2)
      authority from: f, should_be: 1.0
    end
  end

  context "for channels" do
  end

  context "for topics" do
    it "for a user without history in Factlink the authority should be 0.0" do
      t1 = create :topic
      authority of: u1, from: t1, should_be: 0.0
    end

    it "should not give authority on a topic when creating a fact in it" do
      f = create :fact, created_by: u1
      c = create :channel, title: "foo"
      authority of:u1, from: Topic.by_title("foo"), should_be: 0.0
    end


    it "should not give authority on a topic with a fact in it with only one supporting fact" do
      f = create :fact, created_by: u1
      f2 = create :fact, created_by: u1
      c = create :channel, title: "foo"
      f.add_evidence(:supporting,f2,u2)
      authority of:u1, from: Topic.by_title("foo"), should_be: 0.0
    end

    pending "should not give authority on a topic when creating a fact in it" do
      f = create :fact, created_by: u1
      c = create :channel, title: "foo"
      f2 = create :fact, created_by: u1
      f3 = create :fact, created_by: u1
      f.add_evidence(:supporting,f2,u2)
      f.add_evidence(:supporting,f3,u2)
      authority of:u1, from: Topic.by_title("foo"), should_be: 1.0
    end
  end
end

