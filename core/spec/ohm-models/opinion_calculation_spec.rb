require 'spec_helper'


describe "opinion should work as described in the google doc" do
  include BeliefExpressions

  let(:u1) {create(:graph_user)}
  let(:u2) {create(:graph_user)}
  let(:u3) {create(:graph_user)}
  let(:u4) {create(:graph_user)}

  let(:f1) {create(:fact)}
  let(:f2) {create(:fact)}

  # f1 --> f2
  let(:f22) { f2.add_evidence(:supporting,f1,u1) }

  # f1 !-> f2
  let(:f23) { f2.add_evidence(:weakening,f1,u1) }

  before do
    # TODO: remove this once activities are not created in the models any more, but in interactors
    stub_const 'Activity::Subject', Class.new
    Activity::Subject.should_receive(:activity).any_number_of_times
  end

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
