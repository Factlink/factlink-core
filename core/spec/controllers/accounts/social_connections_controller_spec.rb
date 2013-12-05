require 'spec_helper'

describe Accounts::SocialConnectionsController do
  render_views

  describe :callback do
    it 'connects the social account' do
      provider_name = 'facebook'
      uid = '10'
      omniauth_obj = {'provider' => provider_name, 'uid' => uid}
      user = create :full_user

      sign_in user

      controller.request.env['omniauth.auth'] = omniauth_obj
      get :callback, provider_name: provider_name

      expect(response.body).to match 'eventName = "authorized"'
      expect(SocialAccount.first.omniauth_obj['uid']).to eq uid
    end

    it 'replaces social account when already connected to different social account' do
      provider_name = 'facebook'
      old_uid = '10'
      new_uid = '20'
      old_omniauth_obj = {'provider' => provider_name, 'uid' => old_uid}
      new_omniauth_obj = {'provider' => provider_name, 'uid' => new_uid}

      user = create :full_user
      user.social_account(provider_name).update_attributes!(omniauth_obj: old_omniauth_obj)
      sign_in user

      controller.request.env['omniauth.auth'] = new_omniauth_obj
      get :callback, provider_name: provider_name

      expect(response.body).to match 'eventName = "authorized"'
      expect(user.social_account(provider_name).uid).to eq new_uid
    end

    it 'removes spurious earlier social account objects' do
      provider_name = 'facebook'
      omniauth_obj = {'provider' => provider_name, 'uid' => 'uid'}
      create :social_account, :facebook, omniauth_obj: omniauth_obj

      user = create :full_user
      sign_in user

      controller.request.env['omniauth.auth'] = omniauth_obj
      get :callback, provider_name: provider_name

      expect(response.body).to match 'eventName = "authorized"'
      expect(user.social_account(provider_name).uid).to eq 'uid'
    end

    it 'shows an error when another user has been connected to that account already' do
      provider_name = 'facebook'
      omniauth_obj = {'provider' => provider_name, 'uid' => 'uid'}

      user = create :full_user
      sign_in user

      other_user = create :full_user
      other_user.social_account(provider_name).update_attributes!(omniauth_obj: omniauth_obj)

      controller.request.env['omniauth.auth'] = omniauth_obj
      get :callback, provider_name: provider_name

      expect(response.body).to match 'eventName = "account_error"'
    end
  end
end
