require 'spec_helper'

describe Api::SearchController do

  let (:user)  {create :user }

  render_views

  describe "all" do
    it "should render json successful and in the same way (approvals)" do
      FactoryGirl.reload

      user = create :user, username: "Baron"
      create :fact_data, displaystring: "Baron"

      authenticate_user!(user)
      get :all, keywords: "Baron"

      verify { response.body }
    end
  end
end
