require 'spec_helper'

describe Users::ConfirmationsController do
  before do
    # Tests don't pass through the router; see https://github.com/plataformatec/devise
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe :show do
    render_views

    it "confirms the user and redirects to setup page" do
      user = create :user

      get :show, confirmation_token: user.confirmation_token

      user.reload
      expect(user).to be_confirmed

      expect(response).to redirect_to setup_account_path
    end

    it "doesn't allow tokens of more than a month old" do
      user = create :user

      Timecop.travel(40.days) do
        get :show, confirmation_token: user.confirmation_token
      end

      user.reload
      expect(user).to_not be_confirmed

      expect(response.body).to match /needs to be confirmed within 1 month, please request a new one/
    end

    it "redirects to setup page when clicking for a second time" do
      user = create :user

      get :show, confirmation_token: user.confirmation_token
      sign_out(user)
      get :show, confirmation_token: user.confirmation_token

      expect(response).to redirect_to setup_account_path
    end

    it "works when the user is already signed in" do
      user = create :user

      sign_in(user)

      get :show, confirmation_token: user.confirmation_token

      user.reload
      expect(user).to be_confirmed

      expect(response).to redirect_to setup_account_path
    end
  end
end
