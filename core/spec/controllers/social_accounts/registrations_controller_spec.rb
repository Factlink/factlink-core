require 'spec_helper'

describe SocialAccounts::RegistrationsController do
  render_views

  describe :callback do
    context 'connected social account has been found' do
      it 'signs in' do
        provider_name = 'facebook'
        omniauth_obj = {'provider' => provider_name, 'uid' => '10'}
        user = create :full_user

        user.social_account(provider_name).update_attributes!(omniauth_obj: omniauth_obj)

        controller.request.env['omniauth.auth'] = omniauth_obj
        get :callback, provider_name: 'facebook'

        expect(response.body).to match "eventName = 'signed_in'"
      end
    end

    context 'no connected social account has been found' do
      it 'gives an registration form' do
        provider_name = 'facebook'
        omniauth_obj = {'provider' => provider_name, 'uid' => '10'}

        controller.request.env['omniauth.auth'] = omniauth_obj
        get :callback, provider_name: provider_name

        expect(response.body).to match "Create your Factlink account"
      end

      it 'creates a social account without a user' do
        provider_name = 'facebook'
        uid = '10'
        omniauth_obj = {'provider' => provider_name, 'uid' => uid}

        controller.request.env['omniauth.auth'] = omniauth_obj
        get :callback, provider_name: provider_name

        expect(SocialAccount.first.uid).to eq uid
        expect(session[:register_social_account_id]).to eq SocialAccount.first.id.to_s
      end

      it 'shows the form with hint about signing in, and terms' do
        provider_name = 'facebook'
        uid = '10'
        omniauth_obj = {'provider' => provider_name, 'uid' => uid}

        controller.request.env['omniauth.auth'] = omniauth_obj
        get :callback, provider_name: provider_name

        expect(response.body).to match 'fill in your credentials to connect it with Facebook'
        expect(response.body).to match 'By creating an account you accept'
      end

      it 'works when a previous connection was not finished' do
        provider_name = 'facebook'
        uid = '10'

        controller.request.env['omniauth.auth'] = {'provider' => provider_name, 'uid' => uid, 'attempt' => 1}
        get :callback, provider_name: provider_name

        controller.request.env['omniauth.auth'] = {'provider' => provider_name, 'uid' => uid, 'attempt' => 2}
        get :callback, provider_name: provider_name

        expect(response.body).to_not match "eventName = 'social_error'"
        expect(SocialAccount.all.size).to eq 1
        expect(SocialAccount.first.omniauth_obj['attempt']).to eq 2
      end
    end
  end

  describe :create do
    it 'gives an error when no social account has been given' do
      post :create

      expect(response.body).to match "eventName = 'social_error'"
    end

    it 'gives an error when an already connected social account has been given' do
      twitter_account = create :social_account, :twitter, user: create(:full_user)

      session[:register_social_account_id] = twitter_account.id
      post :create

      expect(response.body).to match "eventName = 'social_error'"
    end

    context 'account does not exist' do
      it 'creates a new account to which the social account gets connected' do
        email = 'email@example.org'
        password = '123hoi'
        name = 'Jan Paul Posma'

        omniauth_obj = {'provider' => 'twitter', 'uid' => 'some_twitter_uid',
          'credentials' => {'token' => 'token', 'secret' => 'secret'}, 'info' => {'name' => name}}
        twitter_account = SocialAccount.new provider_name: 'twitter', omniauth_obj: omniauth_obj
        twitter_account.save!

        session[:register_social_account_id] = twitter_account.id
        post :create, user: {email: email, password: password}

        expect(response.body).to match "eventName = 'signed_in'"

        created_user = User.first
        expect(created_user.name).to eq name
        expect(created_user.social_account(:twitter).uid).to eq twitter_account.uid
        expect(created_user).to be_set_up
      end

      it 'shows an error when some field is left open' do
        twitter_account = create :social_account, :twitter

        session[:register_social_account_id] = twitter_account.id
        post :create, user: {email: 'email@example.org'}

        expect(response.body).to match 'be blank'
      end
    end

    context 'account already exists' do
      it 'connects the social account and signs in' do
        email = 'email@example.org'
        password = '123hoi'
        user = create :full_user, email: email, password: password
        twitter_account = create :social_account, :twitter

        session[:register_social_account_id] = twitter_account.id
        post :create, user: {email: email, password: password}

        user.reload
        expect(user.social_account(:twitter).uid).to eq twitter_account.uid

        expect(response.body).to match "eventName = 'signed_in'"
      end

      it 'shows an error if the password is incorrect' do
        email = 'email@example.org'
        password = '123hoi'
        user = create :full_user, email: email, password: password
        twitter_account = create :social_account, :twitter

        session[:register_social_account_id] = twitter_account.id
        post :create, user: {email: email, password: 'wrong'}

        expect(response.body).to match 'incorrect password for existing account'
      end
    end
  end
end
