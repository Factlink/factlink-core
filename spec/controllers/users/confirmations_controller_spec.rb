require 'spec_helper'

describe Users::ConfirmationsController do
  before do
    # Tests don't pass through the router; see https://github.com/plataformatec/devise
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe :show do
    render_views

    before :each do
      Devise.mailer.stub(:send) do |notification, klass, token, opts|
        @token = token
        Devise.mailer.stub(:send).and_return(double(deliver: nil)) # only stub once

        double(deliver: nil)
      end

      @user = create :user
    end

    it "confirms the user and redirects to feed page" do
      get :show, confirmation_token: @token

      @user.reload
      expect(@user).to be_confirmed

      expect(response).to redirect_to feed_path
      expect(subject.current_user).to be_nil
    end

    it "works when the user is already signed in" do
      sign_in(@user)

      get :show, confirmation_token: @token

      @user.reload
      expect(@user).to be_confirmed

      expect(response).to redirect_to feed_path
      expect(subject.current_user).to eq @user
    end

    it "keeps another user signed in" do
      signed_in_user = create :user
      sign_in(signed_in_user)

      get :show, confirmation_token: @token

      @user.reload
      expect(@user).to be_confirmed

      expect(response).to redirect_to feed_path
      expect(subject.current_user).to eq signed_in_user
    end
  end
end
