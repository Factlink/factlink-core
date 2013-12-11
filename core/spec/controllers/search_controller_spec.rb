require 'spec_helper'

describe SearchController do

  let (:user)  {create :full_user }

  render_views

  describe "Search" do
    it "should render json successful and in the same way (approvals)" do
      FactoryGirl.reload

      ElasticSearch.stub synchronous: true

      # This channel should not be displayed since it is not valid.
      # Recalc hasn't run in the mean time so top channels aren't filled in.
      channel = create(:channel, title: "Baron")
      user = create(:full_user, username: "Baron")
      fact = create(:fact, data: create(:fact_data, displaystring: "Baron"), created_by: user.graph_user)

      authenticate_user!(user)
      get :search, s: "Baron", format: :json

      Approvals.verify(response.body, format: :json, name: 'search#search should keep the same content')
    end
  end
end
