require 'spec_helper'

describe Users::ConfirmationsController do
  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe :show do
    it "shows the waiting list page " do
      user = create :user

      get :show, confirmation_token: user.confirmation_token

      response.should render_template 'awaiting_approval'
    end

    it "redirects to setup page when approved" do
      user = create :user, :approved

      get :show, confirmation_token: user.confirmation_token

      response.should redirect_to setup_account_path
    end
  end
end
