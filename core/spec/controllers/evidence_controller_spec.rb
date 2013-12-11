require 'spec_helper'
require 'pavlov_helper'

describe EvidenceController do
  include PavlovSupport
  render_views

  let(:user) { create :user }

  let(:f1) { create :fact, created_by: user.graph_user}
  let(:f2) { create :fact, created_by: user.graph_user}

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

    context "adding a new fact as evidence to a fact" do
      it "should return the existing fact as new evidence" do
        post 'create', fact_id: f1.id, evidence_id: f2.id, type: 'believes', format: :json

        parsed_content = JSON.parse(response.body)
        parsed_content["from_fact"]["id"].should == f2.id

        response.should be_success
      end

      it "should initially believe the fact relation" do
        post 'create', fact_id: f1.id, evidence_id: f2.id, type: 'believes', format: :json

        parsed_content = JSON.parse(response.body)

        argument_votes = parsed_content["argument_votes"]

        expect(argument_votes["current_user_opinion"]).to eq 'believes'
        expect(argument_votes["believes"]).to eq 1
        expect(argument_votes["disbelieves"]).to eq 0
        expect(argument_votes["doubts"]).to eq 0
      end

      it "should not set the user's opinion on the evidence to believe" do
        f2.add_opinion(:disbelieves, user.graph_user)

        post 'create', fact_id: f1.id, evidence_id: f2.id, type: 'believes', format: :json
        response.should be_success

        parsed_content = JSON.parse(response.body)

        fact_votes = parsed_content["from_fact"]["fact_votes"]

        expect(fact_votes["believes"]).to eq 0
        expect(fact_votes["doubts"]).to eq 0
        expect(fact_votes["disbelieves"]).to eq 1
      end
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

      authenticate_user!(user)

      get 'show', fact_id: f1.id, id: fr.id, format: :json
      response.should be_success

      response_body = response.body.to_s
      # strip mongo id, since otherwise comparison will always fail
      response_body.gsub!(/"id":\s*"[^"]*"/, '"id": "<STRIPPED>"')
      Approvals.verify(response_body, format: :json, name: 'evidence#show should keep the same content')
    end
  end
end

describe EvidenceController do
  include PavlovSupport

  let(:user) { create :user }

  let(:f1) { create :fact, created_by: user.graph_user}
  let(:f2) { create :fact, created_by: user.graph_user}

  before do
    # TODO: remove this once activities are not created in the models any more, but in interactors
    stub_const 'Activity::Subject', Class.new
    Activity::Subject.stub(:activity)
  end

  describe :update_opinion do
    it "should be able to set an opinion" do
      fr = f1.add_evidence :supporting, f2, user

      authenticate_user!(user)
      should_check_can :opinionate, fr
      post 'update_opinion', username: 'ohwellwhatever',
        id: 1, fact_id: f1.id, id: fr.id, current_user_opinion: :believes, format: :json

      response.should be_success

      # TODO maybe check if the opinion is also persisted?
    end
  end
end
