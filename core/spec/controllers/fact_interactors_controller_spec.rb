require 'spec_helper'

describe FactInteractorsController do
  include PavlovSupport

  render_views

  let(:user) { FactoryGirl.create(:user) }

  describe :index do
    it "should keep the same content" do
      Timecop.freeze Time.local(1995, 4, 30, 15, 35, 45)
      FactoryGirl.reload # hack because of fixture in check

      fact = create :fact

      fact.add_opiniated :believes, (create :user).graph_user
      5.times do
        fact.add_opiniated :disbelieves, (create :user).graph_user
      end

      get :index, fact_id: fact.id
      response.should be_success

      response_body = response.body.to_s
      # strip mongo id, since otherwise comparison will always fail
      response_body.gsub!(/"id":\s*"[^"]*"/, '"id": "<STRIPPED>"')
      Approvals.verify(response_body, format: :json, name: 'fact_interactors#index should keep the same content')
    end
  end

  describe :show do
    it "should keep the same content" do
      Timecop.freeze Time.local(1995, 4, 30, 15, 35, 45)
      FactoryGirl.reload # hack because of fixture in check

      fact = create :fact

      5.times do
        fact.add_opiniated :disbelieves, (create :user).graph_user
      end

      get :show, fact_id: fact.id, id: 'disbelieves'
      response.should be_success

      response_body = response.body.to_s
      # strip mongo id, since otherwise comparison will always fail
      response_body.gsub!(/"id":\s*"[^"]*"/, '"id": "<STRIPPED>"')
      Approvals.verify(response_body, format: :json, name: 'fact_interactors#show should keep the same content')
    end
  end

end
