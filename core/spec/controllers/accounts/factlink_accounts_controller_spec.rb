require 'spec_helper'

describe Accounts::FactlinkAccountsController do
  render_views

  describe :new do
    it 'renders' do
      get :new

      expect(response).to be_success
    end
  end

  describe :create_session do
    context 'giving correct credentials' do
      it 'signs in' do
        email = 'janpaul@factlink.com'
        password = '123hoi'
        user = create :user, email: email, password: password

        post :create_session, user_new_session: {email: email, password: password}

        expect(response.body).to match 'eventName = "account_success"'
      end
    end

    context 'giving incorrect credentials' do
      it 'shows an error' do
        post :create_session

        expect(response.body).to match 'incorrect email address or password'
      end
    end
  end

  describe :create_account do
    context 'giving correct information' do
      it 'signs in' do
        full_name = 'Jan Paul Posma'
        email = 'janpaul@factlink.com'
        password = '123hoi'

        post :create_account, user_new_account: {
          full_name: full_name, email: email,
          password: password, password_confirmation: password
        }

        expect(response.body).to match 'eventName = "account_success"'
        expect(User.last.email).to eq email
      end
    end

    context 'giving incorrect information' do
      it 'shows an error' do
        post :create_account

        expect(response.body).to match 'is required'
      end
    end
  end
end
