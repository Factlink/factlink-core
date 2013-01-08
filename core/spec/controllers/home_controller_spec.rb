require 'spec_helper'

describe HomeController do
  let (:user)  {FactoryGirl.create :active_user}

  render_views

  describe "GET index" do

    it "should be succesful" do
      get :index
      response.should be_success
    end

    it "should work" do
      authenticate_user!(user)
      get :index
      response.should redirect_to(channel_activities_path user, user.graph_user.stream)
    end

    pending "assigns @facts" do
      # We now cache the @facts from the FactHelper
      get :index
      assigns(:facts).should =~ Fact.all.to_a
    end

    it "assigns @users" do
      get :index
      assigns(:users).to_a.should =~ User.all.to_a
    end

    it "renders the index template" do
      get :index
      response.should render_template("index")
    end

  end

  describe "Routed to general pages should work" do
    it "should be routed to for valid templates" do
      {get: "/p/about"}.should route_to controller: 'home', action: 'pages', name: 'about'
    end

    it "should not be routed with directory traversal" do
      {get: "/p/../../../../etc/passwd"}.should_not be_routable
    end
    it "should be able to retrieve a valid template" do
      get :pages, name: 'about'
      response.should be_success
    end
  end
end
