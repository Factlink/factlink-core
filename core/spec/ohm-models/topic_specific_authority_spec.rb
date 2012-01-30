require 'spec_helper'


describe "beliefs should work as described in the google doc" do
  include TopicBeliefExpressions

  let(:u1) {FactoryGirl.create(:graph_user)}
  let(:u2) {FactoryGirl.create(:graph_user)}
  let(:u3) {FactoryGirl.create(:graph_user)}
  let(:u4) {FactoryGirl.create(:graph_user)}

  let(:f1) {FactoryGirl.create(:fact)}
  let(:f2) {FactoryGirl.create(:fact)}
  let(:f3) {FactoryGirl.create(:fact)}
  let(:f4) {FactoryGirl.create(:fact)}
  let(:f5) {FactoryGirl.create(:fact)}
  let(:f6) {FactoryGirl.create(:fact)}
  let(:f7) {FactoryGirl.create(:fact)}

  let(:t1) {FactoryGirl.create(:topic)}
  let(:t2) {FactoryGirl.create(:topic)}
  let(:t3) {FactoryGirl.create(:topic)}

  # Scenario A (a user without any history in Factlink):
  # a(U1) = 1
  it "for a user without history in Factlink the authority should be 0.0" do
    authority of: u1, on: t1, should_be: 0.0
  end

end

