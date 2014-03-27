require 'spec_helper'

describe SearchController do

  let (:user)  {create :user }

  render_views

  describe "Search" do
    it "should render json successful and in the same way (approvals)" do
      FactoryGirl.reload

      ElasticSearch.stub synchronous: true

      user = create(:user, username: "Baron")
      Backend::Users.index_user username: user.username

      create(:fact, data: create(:fact_data, displaystring: "Baron"))

      authenticate_user!(user)
      get :search, s: "Baron", format: :json

      verify { response.body }
    end
  end
end
