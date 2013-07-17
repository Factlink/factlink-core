require 'spec_helper'

describe FactInteractorsController do
  include PavlovSupport

  render_views

  let(:user) { FactoryGirl.create(:user) }

  describe :interactors do
    it "should keep the same content" do
      Timecop.freeze Time.local(1995, 4, 30, 15, 35, 45)
      FactoryGirl.reload # hack because of fixture in check

      fact = create :fact

      fact.add_opiniated :believes, (create :user).graph_user
      5.times do
        fact.add_opiniated :disbelieves, (create :user).graph_user
      end

      get :interactors, id: fact.id
      response.should be_success

      response_body = response.body.to_s
      # strip mongo id, since otherwise comparison will always fail
      response_body.gsub!(/"id":\s*"[^"]*"/, '"id": "<STRIPPED>"')
      Approvals.verify(response_body, format: :json, name: 'fact_interactors#interactors should keep the same content')
    end
  end

  describe :filtered_interactors do
    it "should keep the same content" do
      Timecop.freeze Time.local(1995, 4, 30, 15, 35, 45)
      FactoryGirl.reload # hack because of fixture in check

      fact = create :fact

      5.times do
        fact.add_opiniated :disbelieves, (create :user).graph_user
      end

      get :filtered_interactors, id: fact.id, type: 'disbelieves'
      response.should be_success

      response_body = response.body.to_s
      # strip mongo id, since otherwise comparison will always fail
      response_body.gsub!(/"id":\s*"[^"]*"/, '"id": "<STRIPPED>"')
      Approvals.verify(response_body, format: :json, name: 'fact_interactors#filtered_interactors should keep the same content')
    end
  end

end
