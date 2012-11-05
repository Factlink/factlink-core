require 'spec_helper'


describe "topic specific authority"  do
  include TopicBeliefExpressions

  let(:u1) { create :graph_user }
  let(:u2) { create :graph_user }
  let(:u3) { create :graph_user }
  let(:u4) { create :graph_user }

  let(:ch1) { create :channel }

  let(:fact_of_u1_which_supports_two) do
    f   = create :fact, created_by: u1
    sf1 = create :fact, created_by: u2
    sf2 = create :fact, created_by: u2

    sf1.add_evidence(:supporting,f,u2)
    sf2.add_evidence(:supporting,f,u2)

    f
  end

  context "from facts" do
    it "should give zero authority when a fact is only created" do
      f = create :fact, created_by: u1

      authority from: f, should_be: 0.0
    end

    it "should give authority for a fact with supporting evidence" do
      authority from: fact_of_u1_which_supports_two, should_be: 1.0
    end
  end

  context "from channels" do
    it "should give zero authority to a user who hasn't done anything" do
      authority from: ch1, for: u1, should_be: 0.0
    end
    it "should forward the authority from the facts it contains" do
      ch1.add_fact(fact_of_u1_which_supports_two)

      authority from: ch1, for: u1, should_be: 1.0
      authority from: ch1, for: u4, should_be: 0.0
    end
  end

  context "from topics" do
    it "for a user without history in Factlink the authority should be 0.0" do
      t1 = create :topic
      authority for: u1, from: t1, should_be: 0.0
    end

    it "should not give authority on a topic when creating a fact in it" do
      f = create :fact, created_by: u1

      c = create :channel, title: "foo"
      c.add_fact f

      foo_t = Topic.by_title("foo")

      authority for:u1, from: foo_t, should_be: 0.0
    end


    it "should not give authority on a topic with a fact in it with only one supporting fact" do
      # TODO: remove this once activities are not created in the models any more, but in interactors
      stub_const 'Activity::Subject', Class.new
      Activity::Subject.should_receive(:activity).any_number_of_times

      f = create :fact, created_by: u1
      f2 = create :fact, created_by: u1
      f.add_evidence(:supporting,f2,u2)

      c = create :channel, title: "foo"
      c.add_fact(f)

      foo_t = Topic.by_title "foo"

      authority for:u1, from: foo_t, should_be: 0.0
    end

    it "should give authority on a topic when a fact with authority is in it" do
      foo_ch = create :channel, title: "foo"
      foo_ch.add_fact(fact_of_u1_which_supports_two)
      foo_t = Topic.by_title "foo"
      authority for:u1, from: foo_t, should_be: 1.0
    end
  end

  context "on facts" do
    it "should give a user authority on a fact in a topic it knows something about" do
      foo_ch = create :channel, title: "foo"
      foo_ch.add_fact(fact_of_u1_which_supports_two)

      fact2 = create :fact
      foo_ch.add_fact fact2

      authority for:u1, on: fact2, should_be: 1.0
    end
  end
end

