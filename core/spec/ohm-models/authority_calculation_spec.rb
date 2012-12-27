require 'spec_helper'


describe "authority should work as described in the google doc" do
  include BeliefExpressions

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

  before do
    # TODO: remove this once activities are not created in the models any more, but in interactors
    stub_const 'Activity::Subject', Class.new
    Activity::Subject.should_receive(:activity).any_number_of_times
    Fact.any_instance.stub(:add_to_created_facts).and_return(true)
  end

  # Scenario A (a user without any history in Factlink):
  # a(U1) = 1
  it "for a user without history in Factlink the authority should be 1.0" do
    a(u1) == 1.0
  end

  # Scenario B (a user that has only believed one fact):
  # b(U1, F1)
  # a(U1) = 1
  # Should have no impact in demo version
  it "for a user that believes one fact the authority should be 1.0" do
    b(u1, f1)
    a(u1) == 1.0
  end


  # Scenario C (a user has created only one fact):
  # c(U1, F1)
  # a(U1) = 1
  # Should have no impact
  it "should be 1.0 when a user has create one fact" do
    @f1 = FactoryGirl.create :fact, created_by: u1
    a(u1) == 1.0
  end

  # Scenario D (a user has created only one fact. Another user has believed the fact):
  # c(U1, F1)
  # b(U2, F1)
  # a(U1) = 1
  it "should be 1.0 when another user believes a fact created by the user" do
    @f1 = FactoryGirl.create :fact, created_by: u1
    b(u2, @f1)
    a(u1) == 1.0
  end

  # Scenario E (a user has created only one fact. The fact is used to support another fact):
  # c(U1, F1)
  # F22 = (F1 -> F2)
  # a(U1) = 1
  it "should have an authority of 1.0 when user created one fact which is supported by another fact" do
    @f1 = FactoryGirl.create :fact, created_by: u1
    f2.add_evidence(:supporting, @f1, u1)
    a(u1) == 1.0
  end

  # Scenario F (a user has created a fact that is used multiple times):
  # c(U1, F1)
  # F22 = (F1 -> F2)
  # c(U2, F22)
  # F23 = (F1 -> F3)
  # c(U2, F23)
  # a(U1) = 2
  pending "should have a higher authority when a fact is used multiple times" do
    @f1 = FactoryGirl.create :fact, created_by: u1
    f2.add_evidence(:supporting, @f1, u2)
    f3.add_evidence(:supporting, @f1, u2)

    a(u1) == 2
  end

  # Scenario G (a user has created multiple facts that are used multiple times):
  # c(U1, F1)
  # F22 = (F1 -> F2)
  # c(U2, F22)
  # F23 = (F1 -> F3)
  # c(U2, F23)
  # c(U1, F4)
  # F42 = (F4 -> F5)
  # c(U2, F42)
  # F43 = (F4 -> F6)
  # c(U2, F43)
  # a(U1) = 3
  #
  # a(U1) = 1 + log(2) + log(2) = 3
  pending "should have an auhority of3 when 2 facts are used twice" do
    @f1 = FactoryGirl.create :fact, created_by: u1
    @f4 = FactoryGirl.create :fact, created_by: u1

    f2.add_evidence(:supporting, @f1, u2)
    f3.add_evidence(:supporting, @f1, u2)

    f5.add_evidence(:supporting, @f4, u2)
    f6.add_evidence(:supporting, @f4, u2)

    a(u1) == 3
  end

  # Scenario H (a user has created multiple facts that are used multiple times, self generated links don’t count):
  # c(U1, F1)
  # F22 = (F1 -> F2)
  # c(U1, F22)
  # F23 = (F1 -> F3)
  # c(U2, F23)
  # c(U1, F4)
  # F42 = (F4 -> F5)
  # c(U1, F42)
  # F43 = (F4 -> F6)
  # c(U2, F43)
  # a(U1) = 1
  #
  # a(U1) = 1 + log(1) + log(1) = 1
  it "should count self generated links" do
    @f1 = FactoryGirl.create :fact, created_by: u1
    @f4 = FactoryGirl.create :fact, created_by: u1

    # By the user himself
    f2.add_evidence(:supporting, @f1, u1)

    # By another user
    f3.add_evidence(:supporting, @f1, u2)

    # By the user himself
    f5.add_evidence(:supporting, @f4, u1)

    # By another user
    f6.add_evidence(:supporting, @f4, u2)

    a(u1) == 1.0
  end

  # Scenario I (a user has created multiple facts that are used multiple times):
  # c(U1, F1)
  # F22 = (F1 -> F2)
  # c(U2, F22)
  # F23 = (F1 -> F3)
  # c(U2, F23)
  # c(U1, F4)
  # F42 = (F4 -> F5)
  # c(U2, F42)
  # F43 = (F4 -> F6)
  # c(U2, F43)
  # a(U1) = 3
  #
  # a(U1) = 1 + log(2) + log(2) = 3
  pending "should have an auhority of 3 when 2 facts are used for support and two for weakening" do
    @f1 = FactoryGirl.create :fact, created_by: u1
    @f4 = FactoryGirl.create :fact, created_by: u1

    f2.add_evidence(:supporting, @f1, u2)
    f3.add_evidence(:supporting, @f1, u2)

    f5.add_evidence(:weakening, @f4, u2)
    f6.add_evidence(:weakening, @f4, u2)

    a(u1) == 3
  end
end
