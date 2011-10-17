require 'spec_helper'

describe RelatedUsersCalculator
  let(:u1) { FactoryGirl.create(:user).graph_user }
  let(:u2) { FactoryGirl.create(:user).graph_user }
  let(:u3) { FactoryGirl.create(:user).graph_user }

  let (:f1) {FactoryGirl.create(:fact) }
  let (:f2) {FactoryGirl.create(:fact) }
  let (:f3) {FactoryGirl.create(:fact) }

  describe "for an empty list" do
    it {subject.related_facts([]).to_a.should =~ []}
  end
  describe "for a list with one fact with one believer" do
    before do
      f1.add_opiniated(:believes, u1)
      f2.add_opiniated(:believes, u2)
      f3.add_opiniated(:believes, u1)
    end
    it {subject.related_facts([f1]).to_a.should =~ [u1]}
    it {subject.related_facts([f1,f2]).to_a.should =~ [u1,u2]}
    it {subject.related_facts([f1,f2,f3]).to_a.should =~ [u1,u2]}
end