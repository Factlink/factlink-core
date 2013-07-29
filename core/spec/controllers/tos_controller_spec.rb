require 'spec_helper'

describe TosController do
  let(:user) { create :user, agrees_tos: false }

  describe :show do
    it "should render show" do
      authenticate_user!(user)
      get :show
      response.should render_template(:show)
    end
  end

  describe :update do
    context "with valid credentials" do
      it "should work with" do
        start_the_tour_path = '/foo/bar'
        ApplicationController.any_instance
                .stub start_the_tour_path: start_the_tour_path
        authenticate_user!(user)
        should_check_can :sign_tos, user

        user.should_receive(:sign_tos).with(true).and_return(true)

        post :update, user: {agrees_tos: 1}
        response.should redirect_to(start_the_tour_path)
      end
    end
    context "with invalid credentials" do
      it "should show the show again" do
        authenticate_user!(user)
        should_check_can :sign_tos, user

        user.should_receive(:sign_tos).with(false).and_return(false)

        post :update, user: {agrees_tos: 0}
        response.should render_template(:show)
      end
    end
  end

end
