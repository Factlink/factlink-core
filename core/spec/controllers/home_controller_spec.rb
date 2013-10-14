require 'spec_helper'

describe HomeController do
  let (:user)  {create :full_user}

  render_views

  describe "GET index" do
    it "should work" do
      authenticate_user!(user)
      get :index
      response.should redirect_to(feed_path user)
    end

    it "renders the index template" do
      get :index
      response.should be_success
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
