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

    it "shows in-your-browser page when not signed in" do
      get :index
      expect(response.body).to match 'Share your knowledge for a better world'
    end
  end
end
