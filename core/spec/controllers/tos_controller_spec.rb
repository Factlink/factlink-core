require 'spec_helper'

describe TosController do
  let(:user) { FactoryGirl.create :user, agrees_tos: false }

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
        authenticate_user!(user)
        should_check_can :sign_tos, user

        user.should_receive(:sign_tos).with(true, 'Sjonnie', 'Akkermans').and_return(true)

        post :update, user: {agrees_tos: 1, tos_first_name: 'Sjonnie', tos_last_name: 'Akkermans'}
        response.should redirect_to(almost_done_path)
      end
    end
    context "with invalid credentials" do
      it "should show the show again" do
        authenticate_user!(user)
        should_check_can :sign_tos, user

        user.should_receive(:sign_tos).with(false, 'Sjonnie', 'Akkermans').and_return(false)

        post :update, user: {agrees_tos: 0, tos_first_name: 'Sjonnie', tos_last_name: 'Akkermans'}
        response.should render_template(:show)
      end
    end
  end

end
