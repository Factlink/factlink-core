require 'spec_helper'
require 'pavlov_helper'

describe SupportingEvidenceController do
  include PavlovSupport
  render_views

  let(:user) {create(:user)}

  let(:f1) {create(:fact)}
  let(:f2) {create(:fact)}

  before do
    # TODO: remove this once activities are not created in the models any more, but in interactors
    stub_const 'Activity::Subject', Class.new
    Activity::Subject.should_receive(:activity).any_number_of_times
  end

  describe :combined_index do
    let(:current_user){create :user}

    it 'response with success' do
      fact_id = 1
      authenticate_user!(current_user)
      controller.should_receive(:interactor).
        with(:"evidence/for_fact_id", fact_id.to_s, :supporting).
        and_return []

      get :combined_index, fact_id: fact_id, format: :json

      response.should be_success
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
end

describe EvidenceController do
  include PavlovSupport

  let(:user) {create(:user)}

  let(:f1) {create(:fact)}
  let(:f2) {create(:fact)}

  before do
    # TODO: remove this once activities are not created in the models any more, but in interactors
    stub_const 'Activity::Subject', Class.new
    Activity::Subject.should_receive(:activity).any_number_of_times
  end

  describe :set_opinion do
    it "should be able to set an opinion" do
      fr = f1.add_evidence :supporting, f2, user

      authenticate_user!(user)
      should_check_can :opinionate, fr
      post :set_opinion, username: 'ohwellwhatever', id: 1, fact_id: f1.id, id: fr.id, type: :believes, format: :json

      response.should be_success

      #todo: maybe check if the opinion is also persisted?
    end
  end
end
