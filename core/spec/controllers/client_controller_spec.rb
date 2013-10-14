require 'spec_helper'

describe ClientController do
  render_views

  let(:user) { create(:full_user) }

  describe :blank do
    it 'should render' do
      get :blank
      expect(response).to be_success
    end
  end

  describe :facts_new do
    it 'should render' do
      authenticate_user!(user)
      get :facts_new
      expect(response).to be_success
    end
  end

  describe :intermediate do
    it 'should render' do
      get :intermediate
      expect(response).to be_success
    end
  end
end
