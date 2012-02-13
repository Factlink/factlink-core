require 'spec_helper'


describe "beliefs should work"  do
  include TopicBeliefExpressions

  let(:u1) { create :graph_user }
  let(:u2) { create :graph_user }
  let(:u3) { create :graph_user }
  let(:u4) { create :graph_user }

  let(:ch1) { create :channel }

  let(:fact_of_u1_with_two_supporting) do
    f   = create :fact, created_by: u1
    sf1 = create :fact, created_by: u2
    sf2 = create :fact, created_by: u2

    f.add_evidence(:supporting,sf1,u2)
    f.add_evidence(:supporting,sf2,u2)

    f
  end

  before :all do
    load_topic_specific_authority
  end

  after :all do
    load_global_authority
  end


  context "from facts" do
    it "should give zero authority when a fact is only created" do
      f = create :fact, created_by: u1

      authority from: f, should_be: 0.0
    end

    it "should give authority for a fact with supporting evidence" do
      authority from: fact_of_u1_with_two_supporting, should_be: 1.0
    end
  end

  context "from channels" do
    it "should give zero authority to a user who hasn't done anything" do
      authority from: ch1, for: u1, should_be: 0.0
    end
    it "should forward the authority from the facts it contains" do
      ch1.add_fact(fact_of_u1_with_two_supporting)

      authority from: ch1, should_be: 1.0
    end
  end

  context "from topics" do
    it "for a user without history in Factlink the authority should be 0.0" do
      t1 = create :topic
      authority of: u1, from: t1, should_be: 0.0
    end

    it "should not give authority on a topic when creating a fact in it" do
      f = create :fact, created_by: u1

      c = create :channel, title: "foo"
      c.add_fact f

      foo_t = create :topic, title: "foo"

      authority of:u1, from: foo_t, should_be: 0.0
    end


    it "should not give authority on a topic with a fact in it with only one supporting fact" do
      f = create :fact, created_by: u1
      f2 = create :fact, created_by: u1
      f.add_evidence(:supporting,f2,u2)

      c = create :channel, title: "foo"
      c.add_fact(f)

      foo_t = create :topic, title: "foo"

      authority of:u1, from: foo_t, should_be: 0.0
    end

    it "should give authority on a topic when a fact with authority is in it" do
      foo_ch = create :channel, title: "foo"
      foo_ch.add_fact(fact_of_u1_with_two_supporting)
      foo_t = create :topic, title: "foo"
      authority of:u1, from: foo_t, should_be: 1.0
    end
  end

  context "on facts" do
    it "should give a user authority on a fact in a topic it knows something about" do
      foo_ch = create :channel, title: "foo"
      foo_ch.add_fact(fact_of_u1_with_two_supporting)
      foo_t = create :topic, title: "foo"

      fact2 = create :fact
      foo_ch.add_fact fact2

      authority of:u1, on: fact2, should_be: 1.0
    end
  end
end

