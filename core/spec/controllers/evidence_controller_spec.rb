require 'spec_helper'
require 'pavlov_helper'

describe SupportingEvidenceController do
  include PavlovSupport
  render_views

  let(:user) {create :user}

  let(:f1) {create :fact, created_by: user.graph_user}
  let(:f2) {create :fact, created_by: user.graph_user}

  before do
    # TODO: remove this once activities are not created in the models any more, but in interactors
    stub_const 'Activity::Subject', Class.new
    Activity::Subject.stub(:activity)
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
        parsed_content["from_fact"]["displaystring"].should == displaystring

        FactRelation[parsed_content["id"].to_i].fact.id.should == f1.id
      end
    end

    context "adding a new fact as evidence to a fact" do
      it "should return the existing fact as new evidence" do
        post 'create', fact_id: f1.id, evidence_id: f2.id, format: :json

        parsed_content = JSON.parse(response.body)
        parsed_content["from_fact"]["id"].should == f2.id

        response.should be_success
      end

      it "should initially believe the fact relation" do
        post 'create', fact_id: f1.id, evidence_id: f2.id, format: :json

        parsed_content = JSON.parse(response.body)

        expect(parsed_content["current_user_opinion"]).to eq 'believes'
        expect(parsed_content["impact"]).to eq 0.0
      end

      it "should not set the user's opinion on the evidence to believe" do
        f2.add_opinion(:disbelieves, user.graph_user)
        Pavlov.command(:'opinions/recalculate_fact_opinion', fact: f2)

        post 'create', fact_id: f1.id, evidence_id: f2.id, format: :json
        response.should be_success

        parsed_content = JSON.parse(response.body)

        opinions = parsed_content["from_fact"]["fact_wheel"]["opinion_types"]

        opinions["believe"]["percentage"].should == 0
        opinions["doubt"]["percentage"].should == 0
        opinions["disbelieve"]["percentage"].should == 100
      end
    end
  end
end

describe EvidenceController do
  include PavlovSupport

  let(:user) {create :user}

  let(:f1) {create :fact, created_by: user.graph_user}
  let(:f2) {create :fact, created_by: user.graph_user}

  before do
    # TODO: remove this once activities are not created in the models any more, but in interactors
    stub_const 'Activity::Subject', Class.new
    Activity::Subject.stub(:activity)
  end

  describe :set_opinion do
    it "should be able to set an opinion" do
      fr = f1.add_evidence :supporting, f2, user

      authenticate_user!(user)
      should_check_can :opinionate, fr
      post :set_opinion, username: 'ohwellwhatever', id: 1, fact_id: f1.id, id: fr.id, type: :believes, format: :json

      response.should be_success

      # TODO maybe check if the opinion is also persisted?
    end
  end

  describe :show do
    render_views

    it "should render json succesfully" do
      Timecop.freeze Time.local(1995, 4, 30, 15, 35, 45)
      FactoryGirl.reload # hack because of fixture in check

      fr = f1.add_evidence :supporting, f2, user
      f2.add_opinion(:believes, user.graph_user)
      fr.add_opinion(:believes, user.graph_user)
      FactGraph.recalculate

      authenticate_user!(user)

      get :show, id: fr.id, format: :json
      response.should be_success

      response_body = response.body.to_s
      # strip mongo id, since otherwise comparison will always fail
      response_body.gsub!(/"id":\s*"[^"]*"/, '"id": "<STRIPPED>"')
      Approvals.verify(response_body, format: :json, name: 'evidence#show should keep the same content')
    end
  end
end
