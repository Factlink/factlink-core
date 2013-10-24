require 'spec_helper'

describe SocialAccountsController do
  render_views

  describe :callback do
    context 'not yet signed in' do
      it 'signs in when a social account has been found' do
        provider_name = 'facebook'
        omniauth_obj = {'provider' => provider_name, 'uid' => '10'}
        user = create :full_user

        user.social_account(provider_name).update_attributes!(omniauth_obj: omniauth_obj)

        controller.request.env['omniauth.auth'] = omniauth_obj
        get :callback, provider_name: 'facebook'

        expect(response.body).to match "eventName = 'signed_in'"
      end

      it 'gives an registration form when no user can be found' do
        provider_name = 'facebook'
        omniauth_obj = {'provider' => provider_name, 'uid' => '10'}
        user = create :full_user

        controller.request.env['omniauth.auth'] = omniauth_obj
        get :callback, provider_name: 'facebook'

        expect(response.body).to match "Create your Factlink account"
      end
    end

    context 'already signed in' do
      it 'connects the social account' do
        provider_name = 'facebook'
        uid = '10'
        omniauth_obj = {'provider' => provider_name, 'uid' => uid}
        user = create :full_user

        sign_in user

        controller.request.env['omniauth.auth'] = omniauth_obj
        get :callback, provider_name: 'facebook'

        expect(response.body).to match "eventName = 'authorized'"
        expect(SocialAccount.first.omniauth_obj['uid']).to eq uid
      end

      it 'shows error when already connected to different user' do
        provider_name = 'facebook'
        omniauth_obj = {'provider' => provider_name, 'uid' => '10'}
        other_omniauth_obj = {'provider' => provider_name, 'uid' => '20'}

        user = create :full_user
        user.social_account(provider_name).update_attributes!(omniauth_obj: omniauth_obj)
        sign_in user

        controller.request.env['omniauth.auth'] = other_omniauth_obj
        get :callback, provider_name: 'facebook'

        expect(response.body).to match "eventName = 'social_error'"
      end
    end
  end

  describe :sign_up_or_in do
    it 'should a form containing the provider name' do
      twitter_account = create :social_account, :twitter

      post :sign_up_or_in, user: {social_account_id: twitter_account.id}

      expect(response.body).to match 'fill in your details to connect with Twitter'
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

        post :sign_up_or_in, user: {email: email, password: password, social_account_id: twitter_account.id}

        expect(response.body).to match "eventName = 'signed_in'"
        expect(User.first.name).to eq name
        expect(User.first.social_account(:twitter).uid).to eq twitter_account.uid
      end

      it 'shows an error when some field is left open' do
        twitter_account = create :social_account, :twitter

        post :sign_up_or_in, user: {email: 'email@example.org', social_account_id: twitter_account.id}

        expect(response.body).to match 'be blank'
      end
    end

    context 'account already exists' do
      it 'connects the social account and signs in' do
        email = 'email@example.org'
        password = '123hoi'
        user = create :full_user, email: email, password: password
        twitter_account = create :social_account, :twitter

        post :sign_up_or_in, user: {email: email, password: password, social_account_id: twitter_account.id}

        user.reload
        expect(user.social_account(:twitter).uid).to eq twitter_account.uid

        expect(response.body).to match "eventName = 'signed_in'"
      end

      it 'shows an error if the password is incorrect' do
        email = 'email@example.org'
        password = '123hoi'
        user = create :full_user, email: email, password: password
        twitter_account = create :social_account, :twitter

        post :sign_up_or_in, user: {email: email, password: 'wrong', social_account_id: twitter_account.id}

        expect(response.body).to match 'incorrect password for existing account'
      end
    end
  end
end
