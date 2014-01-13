require 'spec_helper'

describe SearchController do

  let (:user)  {create :full_user }

  render_views

  describe "Search" do
    it "should render json successful and in the same way (approvals)" do
      FactoryGirl.reload

      ElasticSearch.stub synchronous: true

      user = create(:full_user, username: "Baron")
      fact = create(:fact, data: create(:fact_data, displaystring: "Baron"), created_by: user.graph_user)

      authenticate_user!(user)
      get :search, s: "Baron", format: :json

      Approvals.verify(response.body, format: :json, name: 'search#search should keep the same content')
    end
  end
end
