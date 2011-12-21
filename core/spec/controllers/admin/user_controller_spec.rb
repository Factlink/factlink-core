require 'spec_helper'

describe Admin::UsersController do
  
  include Devise::TestHelpers
  include ControllerMethods
  
  render_views

  let (:user)  {FactoryGirl.create :user, admin: true}
  
  before do
    get_ability
  end
  
  describe "#index" do
    it "should render the index" do
      authenticate_user!(user)
      should_check_can :index, User
      get :index
      response.should be_succes
    end
  end
end