require 'spec_helper'

describe SupportingEvidenceController do
  render_views

  let(:user) {create(:user)}

  let(:f1) {create(:fact)}
  let(:f2) {create(:fact)}
  let(:f3) {create(:fact)}

  before do
    @fr = f1.add_evidence(:supporting, f2, user)
  end

  describe :index do
    it "should show" do
      should_check_can :get_evidence, f1

      get 'index', :fact_id => f1.id, :format => 'json'
      response.should be_success
    end

    it "should show the correct evidence" do
      should_check_can :get_evidence, f1

      get 'index', :fact_id => f1.id, :format => 'json'
      parsed_content = JSON.parse(response.body)
      parsed_content[0]["fact_bubble"]["id"].should == f2.id
    end
  end

  describe :create do

    before do
      authenticate_user!(user)
      should_check_can :add_evidence, f1
    end


    context "adding new evidence to a fact" do

      it "should return the new evidence" do
        displaystring = "Nieuwe features van Mark"

        post 'create', fact_id: f1.id, displaystring: displaystring, format: :json
        response.should be_success

        parsed_content = JSON.parse(response.body)
        parsed_content["fact_bubble"]["displaystring"].should == displaystring

        FactRelation[parsed_content["id"].to_i].fact.id.should == f1.id
      end

    end

    context "adding a new fact as evidence to a fact" do

      it "should return the existing fact as new evidence" do
        post 'create', fact_id: f1.id, evidence_id: f2.id, format: :json

        parsed_content = JSON.parse(response.body)
        parsed_content["fact_bubble"]["fact_id"].should == f2.id

        response.should be_success
      end

      it "should not set the user's opinion on the evidence to believe" do

        f2.add_opinion(:disbelieves, user.graph_user)

        post 'create', fact_id: f1.id, evidence_id: f2.id, format: :json
        response.should be_success

        parsed_content = JSON.parse(response.body)

        opinions = parsed_content["fact_bubble"]["fact_wheel"]["opinion_types"]

        opinions[0]["type"].should == "believe"
        opinions[0]["percentage"].should == 0

        opinions[1]["type"].should == "doubt"
        opinions[1]["percentage"].should == 0

        opinions[2]["type"].should == "disbelieve"
        opinions[2]["percentage"].should == 100
      end
    end

  end


  describe :set_opinion do
    it "should be able to set an opinion" do
      pending "moving the routes - currently does not match routes in Rspec"
      authenticate_user!(user)

      should_check_can :opinionate, @fr
      post :set_opinion, username: 'ohwellwhatever', id: 1, fact_id: f1.id, evidence_id: @fr.id, type: :believes, format: :json

      response.should be_success

      parsed_content = JSON.parse(response.body)
      parsed_content.first.should have_key("fact_bubble")
    end
  end
end
