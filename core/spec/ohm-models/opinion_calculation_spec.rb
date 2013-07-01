require 'spec_helper'


describe "opinion should work as described in the google doc" do
  include BeliefExpressions

  before do
    Commands::Topics::UpdateUserAuthority.stub new: (stub call: nil)
  end

  let(:u1) {create(:graph_user)}
  let(:u2) {create(:graph_user)}
  let(:u3) {create(:graph_user)}
  let(:u4) {create(:graph_user)}

  let(:f1) {create(:fact)}
  let(:f2) {create(:fact)}

  # f1 --> f2
  let(:f1sup2) { f2.add_evidence(:supporting, f1, u1) }

  # f1 !-> f2
  let(:f1weak2) { f2.add_evidence(:weakening, f1, u1) }

  before do
    # TODO: remove this once activities are not created in the models any more, but in interactors
    stub_const 'Activity::Subject', Class.new
    Activity::Subject.should_receive(:activity).any_number_of_times
    Fact.any_instance.stub(:add_to_created_facts).and_return(true)
  end

  it "scenario 0" do
    opinion?(f1) == _(0.0, 0.0, 1.0, 0.0)
  end

  it "scenario 1" do
    believes(u1, f1)
    believes(u2, f1)
    opinion?(f1) == _(1.0, 0.0, 0.0, 2.0)
  end

  it "scenario 2" do
    believes(u1, f1)
    disbelieves(u2, f1)
    opinion?(f1) == _(0.5, 0.5, 0.0, 2.0)
  end

  it "scenario 3" do
    believes(u1, f1)
    doubts(u2, f1)
    opinion?(f1) == _(0.5, 0.0, 0.5, 2.0)
  end

  it "scenario 4" do
    believes(u1, f1)
    believes(u2, f1)
    believes(u2, f1sup2)
    opinion?(f1sup2) == _(1.0, 0.0, 0.0, 1.0)
    opinion?(f2) == _(1.0, 0.0, 0.0, 1.0)
  end

  it "scenario 5" do
    believes(u1, f1)
    believes(u2, f1)
    believes(u2, f1weak2)
    opinion?(f1weak2) == _(1.0, 0.0, 0.0, 1.0)
    opinion?(f2) == _(0.0, 1.0, 0.0, 1.0)
  end

  it "scenario 6" do
    believes(u1, f1)
    believes(u2, f1)
    believes(u1, f1sup2)
    disbelieves(u2, f1sup2)
    opinion?(f1sup2) == _(0.5, 0.5, 0.0, 2.0)
    opinion?(f2) == _(0.5, 0.0, 0.5, 2.0)
  end

  it "scenario 7" do
    believes(u1, f1)
    disbelieves(u2, f1)
    believes(u1, f1sup2)
    opinion?(f1) == _(0.5, 0.5, 0.0, 2.0)
    opinion?(f1sup2) == _(1.0, 0.0, 0.0, 1.0)
    opinion?(f2) == _(0.5, 0.0, 0.5, 1.0)
  end

  it "scenario 8" do
    believes(u1, f1)
    believes(u2, f1)
    believes(u1, f1sup2)
    disbelieves(u3, f2)
    opinion?(f1) == _(1.0, 0.0, 0.0, 2.0)
    opinion?(f1sup2) == _(1.0, 0.0, 0.0, 1.0)
    opinion?(f2) == _(0.5, 0.5, 0.0, 2.0)
  end


end
