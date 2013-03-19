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

  describe :redir do
    it "gives an error when the user is not logged in" do
      get :redir, path: 'sumthing'
      response.code.should == '403'
    end
    it "redirects the user to the path" do
      authenticate_user! user
      base_url = 'http://example.com'
      subject.stub(:jslib_url){ base_url }

      ['foo','bar'].each do |path|
        get :redir, path: path
        response.should redirect_to( base_url + path)
      end
    end
  end

  describe :jslib_url do
    it "constructs a correct JsLibUrl" do
      jslib_url = mock

      FactlinkUI::Application.config.
          should_receive(:jslib_url).
          and_return(jslib_url)

      subject.jslib_url.should == jslib_url
    end
  end
end
