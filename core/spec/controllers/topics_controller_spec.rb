require 'spec_helper'

describe SupportingEvidenceController do
  render_views

  let (:user) {FactoryGirl.create(:user)}

  let (:t1) {FactoryGirl.create(:topic)}

  before do
    @fr = f1.add_evidence(:supporting, f2, user)
  end

  describe :related_users do
    it "should check permisions" do
      should_check_can :show, t1

      get 'related_users', :id => t1.id
      response.should be_success
    end

  end

end