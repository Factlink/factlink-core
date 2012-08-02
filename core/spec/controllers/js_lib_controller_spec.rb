require 'spec_helper'

describe JsLibController do
  render_views

  let (:user) {FactoryGirl.create(:user)}

  describe :show_template do
    it "routes to valid templates" do
      {get: "/templates/_channel_li"}.should route_to controller: 'js_lib', action: 'show_template', name: '_channel_li'
    end

    it "does not route with directory traversal" do
      {get: "/templates/../../../../etc/passwd"}.should_not be_routable
    end

    it "retrieves a valid template" do
      get :show_template, name: '_channel_li'
      response.should be_success
    end

    it "renders the indicator template when not logged in without raising errors" do
      get :show_template, name: 'indicator'
      response.should be_success
    end
  end

  describe :redir do
    it "gives an error when the user is not logged in" do
      get :redir, path: 'sumthing'
      response.code.should == '403'
    end
    it "redirects the user to the path" do
      authenticate_user! user
      base_url = 'http://example.com'
      subject.stub(:redir_url){ base_url }

      ['foo','bar'].each do |path|
        get :redir, path: path
        response.should redirect_to( base_url + path)
      end
    end
  end

  describe :redir_url do
    it "should call our JsLibUrl class with global settings"
  end
end
