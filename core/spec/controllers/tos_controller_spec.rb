require 'spec_helper'

describe TosController do
  include Devise::TestHelpers
  include ControllerMethods

  let(:user) { FactoryGirl.create :user, agrees_tos: false }

  before do
    get_ability
  end

  describe :show do
    it "should render show" do
      authenticate_user!(user)
      should_check_can :show, user
      get :show
      response.should render_template(:show)
    end
  end

  describe :update do
    context "with valid credentials" do
      it "should work with" do
        authenticate_user!(user)
        should_check_can :sign_tos, user

        user.should_receive(:sign_tos).with(true, 'Sjonnie').and_return(true)
      
        post :update, user: {agrees_tos: 1, name: 'Sjonnie'}
        response.should redirect_to(user_profile_path(user.username))
      end
    end
    context "with invalid credentials" do
      it "should show the show again" do
        authenticate_user!(user)
        should_check_can :sign_tos, user

        user.should_receive(:sign_tos).with(false, 'Sjonnie').and_return(false)
      
        post :update, user: {agrees_tos: 0, name: 'Sjonnie'}
        response.should render_template(:show)
      end
    end
  end

end
