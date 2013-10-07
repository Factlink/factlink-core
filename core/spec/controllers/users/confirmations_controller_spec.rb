require 'spec_helper'

describe Users::ConfirmationsController do
  before do
    # Tests don't pass through the router; see https://github.com/plataformatec/devise
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe :show do
    render_views

    it "shows the waiting list page" do
      user = create :user

      get :show, confirmation_token: user.confirmation_token

      response.should render_template 'awaiting_approval'
    end

    it "redirects to setup page when approved" do
      user = create :user, :approved

      get :show, confirmation_token: user.confirmation_token

      response.should redirect_to setup_account_path
    end

    it "doesn't allow tokens of more than a month old" do
      user = create :user

      Timecop.freeze(Date.today + 40) do
        get :show, confirmation_token: user.confirmation_token
      end

      response.body.should match /Email needs to be confirmed within 1 month/
    end

    it "redirects to setup page when approved, when clicking for a second time" do
      user = create :user, :approved

      get :show, confirmation_token: user.confirmation_token
      get :show, confirmation_token: user.confirmation_token

      response.should redirect_to setup_account_path
    end
  end
end
