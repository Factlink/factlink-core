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

    it "should render json successful" do
      Timecop.freeze Time.local(1995, 4, 30, 15, 35, 45)
      FactoryGirl.reload # hack because of fixture in check

      ElasticSearch.stub synchronous: true

      channel = FactoryGirl.create(:channel, title: "Baron")
      user = FactoryGirl.create(:user, username: "Baron")
      fact = FactoryGirl.create(:fact, data: FactoryGirl.create(:fact_data, displaystring: "Baron"))

      authenticate_user!(user)
      get :search, s: "Baron", format: :json
      response.should be_success

      response_body = response.body.to_s
      # strip mongo id, since otherwise comparison will always fail
      response_body.gsub!(/"id":\s*"[^"]*"/, '"id": "<STRIPPED>"')
      Approvals.verify(response_body, format: :json, name: 'search#search should keep the same content')
    end
  end

end
