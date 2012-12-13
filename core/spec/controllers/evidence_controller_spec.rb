require 'spec_helper'
require 'pavlov_helper'

describe SupportingEvidenceController do
  include PavlovSupport
  render_views

  let(:user) {create(:user)}

  let(:f1) {create(:fact)}
  let(:f2) {create(:fact)}
  let(:f3) {create(:fact)}

  before do
    # TODO: remove this once activities are not created in the models any more, but in interactors
    stub_const 'Activity::Subject', Class.new
    Activity::Subject.should_receive(:activity).any_number_of_times

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
      parsed_content[0]["fact_base"]["id"].should == f2.id
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
        parsed_content["fact_base"]["displaystring"].should == displaystring

        FactRelation[parsed_content["id"].to_i].fact.id.should == f1.id
      end

    end

    context "adding a new fact as evidence to a fact" do

      it "should return the existing fact as new evidence" do
        post 'create', fact_id: f1.id, evidence_id: f2.id, format: :json

        parsed_content = JSON.parse(response.body)
        parsed_content["fact_base"]["fact_id"].should == f2.id

        response.should be_success
      end

      it "should set the user's opinion on the added new fact"

      it "should not set the user's opinion on the evidence to believe" do
        f2.add_opinion(:disbelieves, user.graph_user)
        f2.calculate_opinion 2

        post 'create', fact_id: f1.id, evidence_id: f2.id, format: :json
        response.should be_success

        parsed_content = JSON.parse(response.body)

        opinions = parsed_content["fact_base"]["fact_wheel"]["opinion_types"]

        opinions["believe"]["percentage"].should == 0
        opinions["doubt"]["percentage"].should == 0
        opinions["disbelieve"]["percentage"].should == 100
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
      parsed_content.first.should have_key("fact_base")
    end
  end
end
