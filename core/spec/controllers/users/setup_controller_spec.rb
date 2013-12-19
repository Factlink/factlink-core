require 'spec_helper'

describe Users::SetupController do
  let(:user) { create(:user) }
  render_views

  describe :edit do
    it "renders the edit page when authenticated" do
      sign_in user

      should_check_can :set_up, user

      get :edit

      expect(response).to be_success
      expect(response.body).to match 'Please finish your account setup'
    end
  end

  describe :update do
    it 'updates full name' do
      sign_in user

      post :update, user: {full_name: 'full_name'}

      user.reload
      expect(user.full_name).to eq 'full_name'
      expect(user.set_up).to be_true
    end
  end
end
