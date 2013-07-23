require 'spec_helper'

describe JsLibController do
  render_views

  let (:user) {FactoryGirl.create(:user)}

  describe :show_template do
    it "routes to valid templates" do
      {get: "/templates/create"}.should route_to controller: 'js_lib', action: 'show_template', name: 'create'
    end

    it "does not route with directory traversal" do
      {get: "/templates/../../../../etc/passwd"}.should_not be_routable
    end

    it "retrieves a valid template when not logged in" do
      get :show_template, name: 'create'
      response.should be_success
    end

    it "retrieves a valid template when logged in" do
      authenticate_user! user
      get :show_template, name: 'create'
      response.should be_success
    end

    it "renders the indicator template when not logged in without raising errors" do
      subject.stub(:current_user) { user }
      get :show_template, name: 'indicator'
      response.should be_success
    end
  end
end
