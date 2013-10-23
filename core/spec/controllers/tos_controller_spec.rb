require 'spec_helper'

describe TosController do
  let(:user) { create :user }

  describe :show do
    it "should render show" do
      authenticate_user!(user)
      get :show
      response.should render_template(:show)
    end
  end
end
