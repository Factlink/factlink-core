require 'spec_helper'

describe Users::SetupController do
  let(:user) { create(:user) }
  render_views

  describe :edit do
    it "renders the edit page when authenticated" do
      sign_in user

      should_check_can :set_up, user

      get :edit
      response.should be_success
    end
  end

  describe :update do
    it 'resets password and removes reset_password_token' do
      user.reset_password_token = 'some_token'
      user.save!

      sign_in user

      post :update, user: {password: 'example', password_confirmation: 'example'}

      user.reload
      expect(user.valid_password?('example')).to be_true
      expect(user.reset_password_token).to be_nil
    end

    it "returns a user with errors if the passwords don't match" do
      sign_in user

      post :update, user: {password: 'example1', password_confirmation: 'example2'}

      expect(response.body).to match "match confirmation"
    end
  end
end
