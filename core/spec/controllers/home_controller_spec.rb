require 'spec_helper'

describe HomeController do
  let (:user)  {create :user }

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
end
