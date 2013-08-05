require 'spec_helper'


describe "computed opinion" do
  include BeliefExpressions

  before do
    Commands::Topics::UpdateUserAuthority.stub new: (double call: nil)
  end

  let(:u1) { create(:user) }
  let(:u2) { create(:user) }
  let(:u3) { create(:user) }

  let(:gu1) { u1.graph_user }
  let(:gu2) { u2.graph_user }
  let(:gu3) { u3.graph_user }

  let(:f1) { create(:fact) }
  let(:f2) { create(:fact) }

  # f1 --> f2
  let(:f1sup2) { f2.add_evidence(:supporting, f1, gu1) }
  let(:f2sup1) { f1.add_evidence(:supporting, f2, gu1) }

  # f1 !-> f2
  let(:f1weak2) { f2.add_evidence(:weakening, f1, gu1) }

  before do
    # TODO: remove this once activities are not created in the models any more,
    # but in interactors
    stub_const 'Activity::Subject', Class.new
    Activity::Subject.stub(:activity)
    Fact.any_instance.stub(:add_to_created_facts).and_return(true)
  end

  it "should be unsure when without votes and evidence" do
    opinion?(f1) == _(0.0, 0.0, 1.0, 0.0)
  end

  it "should be belief when both votes are" do
    believes(gu1, f1)
    believes(gu2, f1)
    opinion?(f1) == _(1.0, 0.0, 0.0, 2.0)
  end

  it "should be disbelief when both votes are" do
    disbelieves(gu1, f1)
    disbelieves(gu2, f1)
    opinion?(f1) == _(0.0, 1.0, 0.0, 2.0)
  end

  it "should be divided when there's a pro and contra vote" do
    believes(gu1, f1)
    disbelieves(gu2, f1)
    opinion?(f1) == _(0.5, 0.5, 0.0, 2.0)
  end

  it "should be somewhat believed but with authority 2
      when there's a pro and unsure vote" do
    believes(gu1, f1)
    doubts(gu2, f1)
    opinion?(f1) == _(0.5, 0.0, 0.5, 2.0)
  end

  it "should propagate to supported facts, but authority is capped to the
      relation's authority" do
    believes(gu1, f1)
    believes(gu2, f1)
    believes(gu2, f1sup2)
    fact_relation_user_opinion?(f1sup2) == _(1.0, 0.0, 0.0, 1.0)
    opinion?(f2) == _(1.0, 0.0, 0.0, 1.0)
  end

  it "should propagate to supported facts, but authority is capped to the
      supporting fact's authority" do
    believes(gu1, f1)
    believes(gu1, f1sup2)
    believes(gu2, f1sup2)
    fact_relation_user_opinion?(f1sup2) == _(1.0, 0.0, 0.0, 2.0)
    fact_relation_impact_opinion?(f1sup2) == _(1.0, 0.0, 0.0, 1.0)
    opinion?(f2) == _(1.0, 0.0, 0.0, 1.0)
  end

  it "should propagate to weakened facts, but authority is capped to the
      relation's authority" do
    believes(gu1, f1)
    believes(gu2, f1)
    believes(gu2, f1weak2)
    fact_relation_user_opinion?(f1weak2) == _(1.0, 0.0, 0.0, 1.0)
    fact_relation_impact_opinion?(f1weak2) == _(0.0, 1.0, 0.0, 1.0)
    opinion?(f2) == _(0.0, 1.0, 0.0, 1.0)
  end

  it "should propagate to weakened facts, but authority is capped to the
      weaking fact's authority" do
    believes(gu1, f1)
    believes(gu1, f1weak2)
    believes(gu2, f1weak2)
    fact_relation_user_opinion?(f1weak2) == _(1.0, 0.0, 0.0, 2.0)
    fact_relation_impact_opinion?(f1weak2) == _(0.0, 1.0, 0.0, 1.0)
    opinion?(f2) == _(0.0, 1.0, 0.0, 1.0)
  end

  it "should be zero when there is only a supporting fact relation that is
      entirely disputed, even if supporting fact is true" do
    believes(gu1, f1)
    believes(gu2, f1)
    believes(gu1, f1sup2)
    disbelieves(gu2, f1sup2)
    fact_relation_user_opinion?(f1sup2) == _(0.5, 0.5, 0.0, 2.0)
    fact_relation_impact_opinion?(f1sup2) == _(1.0, 0.0, 0.0, 0.0)
    opinion?(f2) == DeadOpinion.zero
  end

  it "should be zero when there is only a supporting fact relation that is
      unanimously believed but the supporting fact is in dispute" do
    believes(gu1, f1)
    disbelieves(gu2, f1)
    believes(gu1, f1sup2)
    opinion?(f1) == _(0.5, 0.5, 0.0, 2.0)
    fact_relation_user_opinion?(f1sup2) == _(1.0, 0.0, 0.0, 1.0)
    fact_relation_impact_opinion?(f1sup2) == _(1.0, 0.0, 0.0, 0.0)
    opinion?(f2) == DeadOpinion.zero
  end

  it "should have an impact with negative authority when more people disbelieve (when specified)" do
    believes(gu1, f1)
    disbelieves(gu1, f1sup2)
    disbelieves(gu2, f1sup2)
    fact_relation_user_opinion?(f1sup2) == _(0.0, 1.0, 0.0, 2.0)
    fact_relation_impact_opinion?(f1sup2) == _(1.0, 0.0, 0.0, 0.0)
    fact_relation_impact_opinion?(f1sup2, allow_negative_authority: true) == _(1.0, 0.0, 0.0, -2.0)
    opinion?(f2) == DeadOpinion.zero
  end

  it "should weigh one vote for supporting evidence as heavily as a direct
      disbelief vote when the supporting fact is strongly believed" do
    believes(gu1, f1)
    believes(gu2, f1)
    believes(gu1, f1sup2)
    disbelieves(gu3, f2)
    opinion?(f1) == _(1.0, 0.0, 0.0, 2.0)
    fact_relation_user_opinion?(f1sup2) == _(1.0, 0.0, 0.0, 1.0)
    fact_relation_impact_opinion?(f1sup2) == _(1.0, 0.0, 0.0, 1.0)
    opinion?(f2) == _(0.5, 0.5, 0.0, 2.0)
  end

  it "should weigh one vote for supporting evidence as heavily as a direct
      disbelief vote when the supporting fact has equal authority to the
      disbelieving user" do
    believes(gu2, f1)
    believes(gu1, f1sup2)
    disbelieves(gu3, f2)
    opinion?(f1) == _(1.0, 0.0, 0.0, 1.0)
    fact_relation_user_opinion?(f1sup2) == _(1.0, 0.0, 0.0, 1.0)
    fact_relation_impact_opinion?(f1sup2) == _(1.0, 0.0, 0.0, 1.0)
    opinion?(f2) == _(0.5, 0.5, 0.0, 2.0)
  end

  it "weighs both the direct vote of a user and evidence added and believed
      by that user." do
    believes(gu1, f1)
    believes(gu1, f2)
    believes(gu1, f1sup2)
    fact_relation_user_opinion?(f1sup2) == _(1.0, 0.0, 0.0, 1.0)
    fact_relation_impact_opinion?(f1sup2) == _(1.0, 0.0, 0.0, 1.0)
    opinion?(f1) == _(1.0, 0.0, 0.0, 1.0)
    opinion?(f2) == _(1.0, 0.0, 0.0, 2.0)
  end

  it "weighs all evidence even if that evidence is only supported by the current
      fact (nasty echo chamber)" do
    facts = Array.new(4) { create(:fact) }
    topfact = facts[0]
    believes(gu1, topfact)

    facts.combination(2).each do |a, b|
      ab = a.add_evidence :supporting, b, gu1
      ba = b.add_evidence :supporting, a, gu1
      believes(gu1, ab)
      believes(gu1, ba)
    end

    opinion?(topfact) == _(1.0, 0.0, 0.0, 4.0)
  end

  describe "supporting comment" do
    it "contributes only to the believed of the fact" do
      comment = add_supporting_comment(gu1, f1)
      believes_comment(gu1, comment)

      comment_user_opinion?(comment) == _(1.0, 0.0, 0.0, 1.0)
      comment_impact_opinion?(comment) == _(1.0, 0.0, 0.0, 1.0)
      opinion?(f1) == _(1.0, 0.0, 0.0, 1.0)
    end

    it "behaves as a fact that is fully believed and has authority 10 times that of the creator" do
      comment = add_supporting_comment(gu1, f1)

      12.times do
        user = create(:graph_user)
        believes_comment(user, comment)
      end

      comment_user_opinion?(comment) == _(1.0, 0.0, 0.0, 12.0)
      comment_impact_opinion?(comment) == _(1.0, 0.0, 0.0, 10.0)
      opinion?(f1) == _(1.0, 0.0, 0.0, 10.0)
    end

    it "also works for one person that has a lot of authority" do
      Authority.on(f1, for: gu1.graph_user) << 20.0

      comment = add_supporting_comment(gu1, f1)
      believes_comment(gu1, comment)

      comment_user_opinion?(comment) == _(1.0, 0.0, 0.0, 21.0)
      comment_impact_opinion?(comment) == _(1.0, 0.0, 0.0, 21.0)
      opinion?(f1) == _(1.0, 0.0, 0.0, 21.0)
    end

    it "should have an impact with negative authority when more people disbelieve (when specified)" do
      comment = add_supporting_comment(gu1, f1)

      disbelieves_comment(gu1, comment)
      disbelieves_comment(gu2, comment)

      comment_user_opinion?(comment) == _(0.0, 1.0, 0.0, 2.0)
      comment_impact_opinion?(comment) == _(1.0, 0.0, 0.0, 0.0)
      comment_impact_opinion?(comment, allow_negative_authority: true) == _(1.0, 0.0, 0.0, -2.0)
      opinion?(f1) == DeadOpinion.zero
    end

  end

  describe "weakening comment" do
    it "contributes only to the disbelieved of the fact" do
      comment = add_weakening_comment(gu1, f1)
      believes_comment(gu1, comment)

      comment_user_opinion?(comment) == _(1.0, 0.0, 0.0, 1.0)
      comment_impact_opinion?(comment) == _(0.0, 1.0, 0.0, 1.0)
      opinion?(f1) == _(0.0, 1.0, 0.0, 1.0)
    end
  end

end
