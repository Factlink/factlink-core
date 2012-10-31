require 'spec_helper'

describe SearchController do

  let (:user)  {FactoryGirl.create :user}

  render_views

  describe "Search" do
    it "should render succesful" do
      authenticate_user!(user)
      get :search, s: "Baron"
      response.should be_success

      response.should render_template("search")
    end
  end

end
