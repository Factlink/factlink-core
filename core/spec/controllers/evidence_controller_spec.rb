require 'spec_helper'

describe EvidenceController do
  include Devise::TestHelpers
  include ControllerMethods
  render_views

  let (:user) {FactoryGirl.create(:user)}

  let (:f1) {FactoryGirl.create(:fact)}
  let (:f2) {FactoryGirl.create(:fact)}
  let (:f3) {FactoryGirl.create(:fact)}

  before do
    f1.add_evidence(:supporting, f2, user)
  end

  describe :index do
    it "should show" do
      get 'index', :fact_id => f1.id, :format => 'json'
      response.should be_succes
    end

    it "should show the correct evidence" do
      get 'index', :fact_id => f1.id, :format => 'json'
      parsed_content = JSON.parse(response.body)
      parsed_content[0]["fact_bubble"]["id"].should == f2.id
    end
  end

end