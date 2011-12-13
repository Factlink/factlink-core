require 'spec_helper'

describe Admin::UsersController do
  
  include Devise::TestHelpers
  include ControllerMethods
  
  render_views

  let (:admin) {FactoryGirl.create(:user, admin: true)}
  let (:user)  {FactoryGirl.create(:user)}
  
  describe "#index" do
    it "should render the index" do
      authenticate_user!(admin)
      get :index
      response.should be_succes
    end
  end
end