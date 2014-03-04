require 'spec_helper'

describe HomeController do
  let (:user)  {create :full_user }

  render_views

  describe "GET index" do
    it "redirects to feed when signed in" do
      authenticate_user!(user)
      get :index
      response.should redirect_to(feed_path)
    end

    it "redirects to in-your-browser page when not signed in" do
      get :index
      response.should redirect_to(in_your_browser_path)
    end
  end

  describe "Routed to general pages should work" do
    it "should be routed to for valid templates" do
      {get: "/about"}.should route_to controller: 'home', action: 'pages', name: 'about'
    end

    it "should be able to retrieve a valid template" do
      get :pages, name: 'about'
      response.should be_success
    end
  end
end
