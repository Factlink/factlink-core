require 'spec_helper'

describe JsLibController do
  render_views

  describe :create do
    it "is renders the create template" do
      get :create
      response.should be_success
    end
  end

  describe :indicator do
    it "renders the indicator template" do
      get :indicator
      response.should be_success
    end
  end
end
