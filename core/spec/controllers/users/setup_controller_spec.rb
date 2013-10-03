require 'spec_helper'

describe Users::SetupController do
  let(:user) { create(:full_user) }

  describe :edit do
    render_views

    it "renders the edit page when authenticated" do
      authenticate_user!(user)

      should_check_can :set_up, user

      get :edit
      response.should be_success
    end
  end
end
