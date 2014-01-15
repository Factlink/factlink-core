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
    Activity.stub(:create)
  end

  describe :create do
    before do
      authenticate_user!(user)
      should_check_can :add_evidence, f1
    end

    context "adding a new fact as evidence to a fact" do
      pending "should return the existing fact as new evidence" do
        post 'create', fact_id: f1.id, evidence_id: f2.id, type: 'believes', format: :json

        parsed_content = JSON.parse(response.body)
        parsed_content["from_fact"]["id"].should == f2.id

        response.should be_success
      end

      pending "should initially believe the fact relation" do
        post 'create', fact_id: f1.id, evidence_id: f2.id, type: 'believes', format: :json

        parsed_content = JSON.parse(response.body)

        tally = parsed_content["tally"]

        expect(tally["current_user_opinion"]).to eq 'believes'
        expect(tally["believes"]).to eq 1
        expect(tally["disbelieves"]).to eq 0
        expect(tally["doubts"]).to eq 0
      end
    end
  end

  describe :show do
    render_views

    pending "should render json succesfully" do
      FactoryGirl.reload

      fr = f1.add_evidence :believes, f2, user
      f2.add_opinion(:believes, user.graph_user)
      fr.add_opinion(:believes, user.graph_user)

      authenticate_user!(user)

      get 'show', fact_id: f1.id, id: fr.id, format: :json

      Approvals.verify(response.body, format: :json, name: 'evidence#show should keep the same content')
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
    Activity.stub(:create)
  end

  describe :update_opinion do
    pending "should be able to set an opinion" do
      fr = f1.add_evidence :believes, f2, user

      authenticate_user!(user)
      should_check_can :opinionate, fr
      post 'update_opinion', username: 'ohwellwhatever',
        id: 1, fact_id: f1.id, id: fr.id, current_user_opinion: :believes, format: :json

      response.should be_success

      # TODO maybe check if the opinion is also persisted?
    end
  end
end
